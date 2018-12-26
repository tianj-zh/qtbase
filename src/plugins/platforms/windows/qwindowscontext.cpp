/****************************************************************************
**
** Copyright (C) 2013 Samuel Gaist <samuel.gaist@edeltech.ch>
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the plugins of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qwindowscontext.h"
#include "qwindowsintegration.h"
#include "qwindowswindow.h"
#include "qwindowskeymapper.h"
#include "qwindowsmousehandler.h"
#include "qwindowspointerhandler.h"
#include "qtwindowsglobal.h"
#include "qwindowsmime.h"
#include "qwindowsinputcontext.h"
#include "qwindowstabletsupport.h"
#include "qwindowstheme.h"
#include <private/qguiapplication_p.h>
#ifndef QT_NO_ACCESSIBILITY
# include "accessible/qwindowsaccessibility.h"
#endif
#if !defined(Q_OS_WINCE) && !defined(QT_NO_SESSIONMANAGER)
# include <private/qsessionmanager_p.h>
# include "qwindowssessionmanager.h"
#endif
#include "qwindowsscreen.h"
#include "qwindowstheme.h"

#include <QtGui/QWindow>
#include <qpa/qwindowsysteminterface.h>
#include <qpa/qplatformnativeinterface.h>
#include <QtGui/QGuiApplication>

#include <QtCore/QSet>
#include <QtCore/QHash>
#include <QtCore/QStringList>
#include <QtCore/QDebug>
#include <QtCore/QSysInfo>
#include <QtCore/QScopedArrayPointer>
#include <QtCore/private/qsystemlibrary_p.h>

#include <QtPlatformSupport/private/qwindowsguieventdispatcher_p.h>

#include <stdlib.h>
#include <stdio.h>
#include <windowsx.h>
#ifndef Q_OS_WINCE
#  include <comdef.h>
#endif

QT_BEGIN_NAMESPACE

Q_LOGGING_CATEGORY(lcQpaWindows, "qt.qpa.windows")
Q_LOGGING_CATEGORY(lcQpaBackingStore, "qt.qpa.backingstore")
Q_LOGGING_CATEGORY(lcQpaEvents, "qt.qpa.events")
Q_LOGGING_CATEGORY(lcQpaFonts, "qt.qpa.fonts")
Q_LOGGING_CATEGORY(lcQpaGl, "qt.qpa.gl")
Q_LOGGING_CATEGORY(lcQpaMime, "qt.qpa.mime")
Q_LOGGING_CATEGORY(lcQpaInputMethods, "qt.qpa.input.methods")
Q_LOGGING_CATEGORY(lcQpaDialogs, "qt.qpa.dialogs")
Q_LOGGING_CATEGORY(lcQpaTablet, "qt.qpa.input.tablet")
Q_LOGGING_CATEGORY(lcQpaAccessibility, "qt.qpa.accessibility")

int QWindowsContext::verbose = 0;

#if !defined(LANG_SYRIAC)
#    define LANG_SYRIAC 0x5a
#endif

static inline bool useRTL_Extensions(QSysInfo::WinVersion ver)
{
    // This is SDK dependent on CE so out of scope for now
    if (QSysInfo::windowsVersion() & QSysInfo::WV_CE_based)
        return false;
    if ((ver & QSysInfo::WV_NT_based) && (ver >= QSysInfo::WV_VISTA)) {
        // Since the IsValidLanguageGroup/IsValidLocale functions always return true on
        // Vista, check the Keyboard Layouts for enabling RTL.
        if (const int nLayouts = GetKeyboardLayoutList(0, 0)) {
            QScopedArrayPointer<HKL> lpList(new HKL[nLayouts]);
            GetKeyboardLayoutList(nLayouts, lpList.data());
            for (int i = 0; i < nLayouts; ++i) {
                switch (PRIMARYLANGID((quintptr)lpList[i])) {
                case LANG_ARABIC:
                case LANG_HEBREW:
                case LANG_FARSI:
                case LANG_SYRIAC:
                    return true;
                default:
                    break;
                }
            }
        }
        return false;
    } // NT/Vista
#ifndef Q_OS_WINCE
    // Pre-NT: figure out whether a RTL language is installed
    return IsValidLanguageGroup(LGRPID_ARABIC, LGRPID_INSTALLED)
                            || IsValidLanguageGroup(LGRPID_HEBREW, LGRPID_INSTALLED)
                            || IsValidLocale(MAKELCID(MAKELANGID(LANG_ARABIC, SUBLANG_DEFAULT), SORT_DEFAULT), LCID_INSTALLED)
                            || IsValidLocale(MAKELCID(MAKELANGID(LANG_HEBREW, SUBLANG_DEFAULT), SORT_DEFAULT), LCID_INSTALLED)
                            || IsValidLocale(MAKELCID(MAKELANGID(LANG_SYRIAC, SUBLANG_DEFAULT), SORT_DEFAULT), LCID_INSTALLED)
                            || IsValidLocale(MAKELCID(MAKELANGID(LANG_FARSI, SUBLANG_DEFAULT), SORT_DEFAULT), LCID_INSTALLED);
#else
    return false;
#endif
}

#if !defined(Q_OS_WINCE) && !defined(QT_NO_SESSIONMANAGER)
static inline QWindowsSessionManager *platformSessionManager() {
    QGuiApplicationPrivate *guiPrivate = static_cast<QGuiApplicationPrivate*>(QObjectPrivate::get(qApp));
    QSessionManagerPrivate *managerPrivate = static_cast<QSessionManagerPrivate*>(QObjectPrivate::get(guiPrivate->session_manager));
    return static_cast<QWindowsSessionManager *>(managerPrivate->platformSessionManager);
}

static inline bool sessionManagerInteractionBlocked()
{
    return platformSessionManager()->isInteractionBlocked();
}
#else
static inline bool sessionManagerInteractionBlocked() { return false; }
#endif

/*!
    \class QWindowsUser32DLL
    \brief Struct that contains dynamically resolved symbols of User32.dll.

    The stub libraries shipped with the MinGW compiler miss some of the
    functions. They need to be retrieved dynamically.

    In addition, touch-related functions are available only from Windows onwards.
    These need to resolved dynamically for Q_CC_MSVC as well.

    \sa QWindowsShell32DLL

    \internal
    \ingroup qt-lighthouse-win
*/

#ifndef Q_OS_WINCE

QWindowsUser32DLL::QWindowsUser32DLL() :
    setLayeredWindowAttributes(0), updateLayeredWindow(0),
    updateLayeredWindowIndirect(0),
    isHungAppWindow(0), isTouchWindow(0),
    registerTouchWindow(0), unregisterTouchWindow(0),
    getTouchInputInfo(0), closeTouchInputHandle(0), setProcessDPIAware(0),
    addClipboardFormatListener(0), removeClipboardFormatListener(0),
    getDisplayAutoRotationPreferences(0), setDisplayAutoRotationPreferences(0),
	getPointerPenInfo(0), getPointerType(0)
{
}

void QWindowsUser32DLL::init()
{
    QSystemLibrary library(QStringLiteral("user32"));
    // MinGW (g++ 3.4.5) accepts only C casts.
    setLayeredWindowAttributes = (SetLayeredWindowAttributes)(library.resolve("SetLayeredWindowAttributes"));
    updateLayeredWindow = (UpdateLayeredWindow)(library.resolve("UpdateLayeredWindow"));
    if (!setLayeredWindowAttributes || !updateLayeredWindow)
        qFatal("This version of Windows is not supported (User32.dll is missing the symbols 'SetLayeredWindowAttributes', 'UpdateLayeredWindow').");

    updateLayeredWindowIndirect = (UpdateLayeredWindowIndirect)(library.resolve("UpdateLayeredWindowIndirect"));
    isHungAppWindow = (IsHungAppWindow)library.resolve("IsHungAppWindow");
    setProcessDPIAware = (SetProcessDPIAware)library.resolve("SetProcessDPIAware");

    if (QSysInfo::windowsVersion() >= QSysInfo::WV_VISTA) {
        addClipboardFormatListener = (AddClipboardFormatListener)library.resolve("AddClipboardFormatListener");
        removeClipboardFormatListener = (RemoveClipboardFormatListener)library.resolve("RemoveClipboardFormatListener");
    }
    getDisplayAutoRotationPreferences = (GetDisplayAutoRotationPreferences)library.resolve("GetDisplayAutoRotationPreferences");
    setDisplayAutoRotationPreferences = (SetDisplayAutoRotationPreferences)library.resolve("SetDisplayAutoRotationPreferences");
	
	if (QSysInfo::windowsVersion() >= QSysInfo::WV_WINDOWS7) {
        isTouchWindow = (IsTouchWindow)(library.resolve("IsTouchWindow"));
        registerTouchWindow = (RegisterTouchWindow)(library.resolve("RegisterTouchWindow"));
        unregisterTouchWindow = (UnregisterTouchWindow)(library.resolve("UnregisterTouchWindow"));
        getTouchInputInfo = (GetTouchInputInfo)(library.resolve("GetTouchInputInfo"));
        closeTouchInputHandle = (CloseTouchInputHandle)(library.resolve("CloseTouchInputHandle"));
	}
	
	if (QSysInfo::windowsVersion() >= QSysInfo::WV_WINDOWS8) {
        enableMouseInPointer = (EnableMouseInPointer)library.resolve("EnableMouseInPointer");
        getPointerType = (GetPointerType)library.resolve("GetPointerType");
        getPointerInfo = (GetPointerInfo)library.resolve("GetPointerInfo");
        getPointerDeviceRects = (GetPointerDeviceRects)library.resolve("GetPointerDeviceRects");
        getPointerTouchInfo = (GetPointerTouchInfo)library.resolve("GetPointerTouchInfo");
        getPointerFrameTouchInfo = (GetPointerFrameTouchInfo)library.resolve("GetPointerFrameTouchInfo");
        getPointerFrameTouchInfoHistory = (GetPointerFrameTouchInfoHistory)library.resolve("GetPointerFrameTouchInfoHistory");
        getPointerPenInfo = (GetPointerPenInfo)library.resolve("GetPointerPenInfo");
        getPointerPenInfoHistory = (GetPointerPenInfoHistory)library.resolve("GetPointerPenInfoHistory");
        skipPointerFrameMessages = (SkipPointerFrameMessages)library.resolve("SkipPointerFrameMessages");
    }
}

bool QWindowsUser32DLL::supportsPointerApi()
{
    return enableMouseInPointer && getPointerType && getPointerInfo && getPointerDeviceRects
            && getPointerTouchInfo && getPointerFrameTouchInfo && getPointerFrameTouchInfoHistory
            && getPointerPenInfo && getPointerPenInfoHistory && skipPointerFrameMessages;
}

/*!
    \class QWindowsShell32DLL
    \brief Struct that contains dynamically resolved symbols of Shell32.dll.

    The stub libraries shipped with the MinGW compiler miss some of the
    functions. They need to be retrieved dynamically.

    \sa QWindowsUser32DLL

    \internal
    \ingroup qt-lighthouse-win
*/

QWindowsShell32DLL::QWindowsShell32DLL()
    : sHCreateItemFromParsingName(0)
    , sHGetKnownFolderIDList(0)
    , sHGetStockIconInfo(0)
    , sHGetImageList(0)
    , sHCreateItemFromIDList(0)
{
}

void QWindowsShell32DLL::init()
{
    QSystemLibrary library(QStringLiteral("shell32"));
    sHCreateItemFromParsingName = (SHCreateItemFromParsingName)(library.resolve("SHCreateItemFromParsingName"));
    sHGetKnownFolderIDList = (SHGetKnownFolderIDList)(library.resolve("SHGetKnownFolderIDList"));
    sHGetStockIconInfo = (SHGetStockIconInfo)library.resolve("SHGetStockIconInfo");
    sHGetImageList = (SHGetImageList)library.resolve("SHGetImageList");
    sHCreateItemFromIDList = (SHCreateItemFromIDList)library.resolve("SHCreateItemFromIDList");
}

QWindowsShcoreDLL::QWindowsShcoreDLL()
    : getProcessDpiAwareness(0)
    , setProcessDpiAwareness(0)
    , getDpiForMonitor(0)
{
}

void QWindowsShcoreDLL::init()
{
    if (QSysInfo::windowsVersion() < QSysInfo::WV_WINDOWS8_1)
        return;
    QSystemLibrary library(QStringLiteral("SHCore"));
    getProcessDpiAwareness = (GetProcessDpiAwareness)library.resolve("GetProcessDpiAwareness");
    setProcessDpiAwareness = (SetProcessDpiAwareness)library.resolve("SetProcessDpiAwareness");
    getDpiForMonitor = (GetDpiForMonitor)library.resolve("GetDpiForMonitor");
}

QWindowsUser32DLL QWindowsContext::user32dll;
QWindowsShell32DLL QWindowsContext::shell32dll;
QWindowsShcoreDLL QWindowsContext::shcoredll;

#endif // !Q_OS_WINCE

QWindowsContext *QWindowsContext::m_instance = 0;

/*!
    \class QWindowsContext
    \brief Singleton container for all relevant information.

    Holds state information formerly stored in \c qapplication_win.cpp.

    \internal
    \ingroup qt-lighthouse-win
*/

typedef QHash<HWND, QWindowsWindow *> HandleBaseWindowHash;

struct QWindowsContextPrivate {

    QWindowsContextPrivate();

    unsigned m_systemInfo;
    QSet<QString> m_registeredWindowClassNames;
    HandleBaseWindowHash m_windows;
    HDC m_displayContext = 0;
    int m_defaultDPI = 96;
    QWindowsKeyMapper m_keyMapper;
    QWindowsMouseHandler m_mouseHandler;
    QWindowsPointerHandler m_pointerHandler;
    QWindowsMimeConverter m_mimeConverter;
    QWindowsScreenManager m_screenManager;
    QSharedPointer<QWindowCreationContext> m_creationContext;
#if !defined(QT_NO_TABLETEVENT) && !defined(Q_OS_WINCE)
    QScopedPointer<QWindowsTabletSupport> m_tabletSupport;
#endif
    const HRESULT m_oleInitializeResult;
    QWindow *m_lastActiveWindow = nullptr;
    bool m_asyncExpose = false;
};

QWindowsContextPrivate::QWindowsContextPrivate()
    : m_systemInfo(0)
    , m_oleInitializeResult(OleInitialize(NULL))
    , m_lastActiveWindow(0), m_asyncExpose(0)
{
    const QSysInfo::WinVersion ver = QSysInfo::windowsVersion();
#ifndef Q_OS_WINCE
    QWindowsContext::user32dll.init();
    QWindowsContext::shell32dll.init();
    QWindowsContext::shcoredll.init();

    if (m_pointerHandler.touchDevice() || m_mouseHandler.touchDevice())
        m_systemInfo |= QWindowsContext::SI_SupportsTouch;
#endif // !Q_OS_WINCE
    m_displayContext = GetDC(0);
    m_defaultDPI = GetDeviceCaps(m_displayContext, LOGPIXELSY);
    if (useRTL_Extensions(ver)) {
        m_systemInfo |= QWindowsContext::SI_RTL_Extensions;
        m_keyMapper.setUseRTLExtensions(true);
    }
    if (FAILED(m_oleInitializeResult)) {
       qWarning() << "QWindowsContext: OleInitialize() failed: "
           << QWindowsContext::comErrorString(m_oleInitializeResult);
    }
}

QWindowsContext::QWindowsContext() :
    d(new QWindowsContextPrivate)
{
#ifdef Q_CC_MSVC
#    pragma warning( disable : 4996 )
#endif
    m_instance = this;
    // ### FIXME: Remove this once the logging system has other options of configurations.
    const QByteArray bv = qgetenv("QT_QPA_VERBOSE");
    if (!bv.isEmpty())
        QLoggingCategory::setFilterRules(QString::fromLocal8Bit(bv));
}

QWindowsContext::~QWindowsContext()
{
#if !defined(QT_NO_TABLETEVENT) && !defined(Q_OS_WINCE)
    d->m_tabletSupport.reset(); // Destroy internal window before unregistering classes.
#endif
    unregisterWindowClasses();
    if (d->m_oleInitializeResult == S_OK || d->m_oleInitializeResult == S_FALSE)
        OleUninitialize();

    d->m_screenManager.clearScreens(); // Order: Potentially calls back to the windows.
    m_instance = 0;
}

bool QWindowsContext::initTouch()
{
    return initTouch(QWindowsIntegration::instance()->options());
}

bool QWindowsContext::initTouch(unsigned integrationOptions)
{
    if (d->m_systemInfo & QWindowsContext::SI_SupportsTouch)
        return true;

    QTouchDevice *touchDevice = (d->m_systemInfo & QWindowsContext::SI_SupportsPointer) ?
                d->m_pointerHandler.ensureTouchDevice() : d->m_mouseHandler.ensureTouchDevice();
    if (!touchDevice)
        return false;

    if (d->m_systemInfo & QWindowsContext::SI_SupportsPointer) {
        QWindowSystemInterfacePrivate::TabletEvent::setPlatformSynthesizesMouse(false);
    } else {
        if (!(integrationOptions & QWindowsIntegration::DontPassOsMouseEventsSynthesizedFromTouch))
            touchDevice->setCapabilities(touchDevice->capabilities() | QTouchDevice::MouseEmulation);
    }

    QWindowSystemInterface::registerTouchDevice(touchDevice);

    d->m_systemInfo |= QWindowsContext::SI_SupportsTouch;

    // A touch device was plugged while the app is running. Register all windows for touch.
    if (QGuiApplicationPrivate::is_app_running) {
        for (QWindowsWindow *w : qAsConst(d->m_windows))
            w->registerTouchWindow();
    }

    return true;
}

bool QWindowsContext::initTablet(unsigned integrationOptions)
{
    Q_UNUSED(integrationOptions);
#if !defined(QT_NO_TABLETEVENT) && !defined(Q_OS_WINCE)
    d->m_tabletSupport.reset(QWindowsTabletSupport::create());
    qCDebug(lcQpaTablet) << "Tablet support: " << (d->m_tabletSupport.isNull() ? QStringLiteral("None") : d->m_tabletSupport->description());
    return true;
#else
    return false;
#endif
}

bool QWindowsContext::initPointer(unsigned integrationOptions)
{
    if (integrationOptions & QWindowsIntegration::DontUseWMPointer)
        return false;

    if (QSysInfo::windowsVersion() < QSysInfo::WV_WINDOWS8)
        return false;

    if (!QWindowsContext::user32dll.supportsPointerApi())
        return false;

    QWindowsContext::user32dll.enableMouseInPointer(TRUE);
    d->m_systemInfo |= QWindowsContext::SI_SupportsPointer;
    return true;
}

void QWindowsContext::setTabletAbsoluteRange(int a)
{
#if !defined(QT_NO_TABLETEVENT) && !defined(Q_OS_WINCE)
    if (!d->m_tabletSupport.isNull())
        d->m_tabletSupport->setAbsoluteRange(a);
#else
    Q_UNUSED(a)
#endif
}

int QWindowsContext::processDpiAwareness()
{
#ifndef Q_OS_WINCE
    int result;
    if (QWindowsContext::shcoredll.getProcessDpiAwareness
        && SUCCEEDED(QWindowsContext::shcoredll.getProcessDpiAwareness(NULL, &result))) {
        return result;
    }
#endif // !Q_OS_WINCE
    return -1;
}

void QWindowsContext::setProcessDpiAwareness(QtWindows::ProcessDpiAwareness dpiAwareness)
{
#ifndef Q_OS_WINCE
    qCDebug(lcQpaWindows) << __FUNCTION__ << dpiAwareness;
    if (QWindowsContext::shcoredll.isValid()) {
        const HRESULT hr = QWindowsContext::shcoredll.setProcessDpiAwareness(dpiAwareness);
        // E_ACCESSDENIED means set externally (MSVC manifest or external app loading Qt plugin).
        // Silence warning in that case unless debug is enabled.
        if (FAILED(hr) && (hr != E_ACCESSDENIED || lcQpaWindows().isDebugEnabled())) {
            qWarning().noquote().nospace() << "SetProcessDpiAwareness("
                << dpiAwareness << ") failed: " << QWindowsContext::comErrorString(hr)
                << ", using " << QWindowsContext::processDpiAwareness();
        }
    } else {
        if (dpiAwareness != QtWindows::ProcessDpiUnaware && QWindowsContext::user32dll.setProcessDPIAware) {
            if (!QWindowsContext::user32dll.setProcessDPIAware())
                qErrnoWarning("SetProcessDPIAware() failed");
        }
    }
#else // !Q_OS_WINCE
    Q_UNUSED(dpiAwareness)
#endif
}

QWindowsContext *QWindowsContext::instance()
{
    return m_instance;
}

unsigned QWindowsContext::systemInfo() const
{
    return d->m_systemInfo;
}

bool QWindowsContext::useRTLExtensions() const
{
    return d->m_keyMapper.useRTLExtensions();
}

QList<int> QWindowsContext::possibleKeys(const QKeyEvent *e) const
{
    return d->m_keyMapper.possibleKeys(e);
}

void QWindowsContext::setWindowCreationContext(const QSharedPointer<QWindowCreationContext> &ctx)
{
    d->m_creationContext = ctx;
}

int QWindowsContext::defaultDPI() const
{
    return d->m_defaultDPI;
}

HDC QWindowsContext::displayContext() const
{
    return d->m_displayContext;
}

QWindow *QWindowsContext::keyGrabber() const
{
    return d->m_keyMapper.keyGrabber();
}

void QWindowsContext::setKeyGrabber(QWindow *w)
{
    d->m_keyMapper.setKeyGrabber(w);
}

// Window class registering code (from qapplication_win.cpp)

QString QWindowsContext::registerWindowClass(const QWindow *w)
{
    Q_ASSERT(w);
    const Qt::WindowFlags flags = w->flags();
    const Qt::WindowFlags type = flags & Qt::WindowType_Mask;
    // Determine style and icon.
    uint style = CS_DBLCLKS;
    bool icon = true;
    // The following will not set CS_OWNDC for any widget window, even if it contains a
    // QOpenGLWidget or QQuickWidget later on. That cannot be detected at this stage.
    if (w->surfaceType() == QSurface::OpenGLSurface || (flags & Qt::MSWindowsOwnDC))
        style |= CS_OWNDC;
    if (!(flags & Qt::NoDropShadowWindowHint) && (QSysInfo::WindowsVersion & QSysInfo::WV_NT_based)
        && (type == Qt::Popup || w->property("_q_windowsDropShadow").toBool())) {
        style |= CS_DROPSHADOW;
    }
    switch (type) {
    case Qt::Tool:
    case Qt::ToolTip:
    case Qt::Popup:
        style |= CS_SAVEBITS; // Save/restore background
        icon = false;
        break;
    case Qt::Dialog:
        if (!(flags & Qt::WindowSystemMenuHint))
            icon = false; // QTBUG-2027, dialogs without system menu.
        break;
    }
    // Create a unique name for the flag combination
    QString cname = QStringLiteral("Qt5QWindow");
    switch (type) {
    case Qt::Tool:
        cname += QStringLiteral("Tool");
        break;
    case Qt::ToolTip:
        cname += QStringLiteral("ToolTip");
        break;
    case Qt::Popup:
        cname += QStringLiteral("Popup");
        break;
    default:
        break;
    }
    if (style & CS_DROPSHADOW)
        cname += QStringLiteral("DropShadow");
    if (style & CS_SAVEBITS)
        cname += QStringLiteral("SaveBits");
    if (style & CS_OWNDC)
        cname += QStringLiteral("OwnDC");
    if (icon)
        cname += QStringLiteral("Icon");

    return registerWindowClass(cname, qWindowsWndProc, style, GetSysColorBrush(COLOR_WINDOW), icon);
}

QString QWindowsContext::registerWindowClass(QString cname,
                                             WNDPROC proc,
                                             unsigned style,
                                             HBRUSH brush,
                                             bool icon)
{
    // since multiple Qt versions can be used in one process
    // each one has to have window class names with a unique name
    // The first instance gets the unmodified name; if the class
    // has already been registered by another instance of Qt then
    // add an instance-specific ID, the address of the window proc.
    static int classExists = -1;

    const HINSTANCE appInstance = static_cast<HINSTANCE>(GetModuleHandle(0));
    if (classExists == -1) {
        WNDCLASS wcinfo;
        classExists = GetClassInfo(appInstance, reinterpret_cast<LPCWSTR>(cname.utf16()), &wcinfo);
        classExists = classExists && wcinfo.lpfnWndProc != proc;
    }

    if (classExists)
        cname += QString::number(reinterpret_cast<quintptr>(proc));

    if (d->m_registeredWindowClassNames.contains(cname))        // already registered in our list
        return cname;

#ifndef Q_OS_WINCE
    WNDCLASSEX wc;
    wc.cbSize       = sizeof(WNDCLASSEX);
#else
    WNDCLASS wc;
#endif
    wc.style        = style;
    wc.lpfnWndProc  = proc;
    wc.cbClsExtra   = 0;
    wc.cbWndExtra   = 0;
    wc.hInstance    = appInstance;
    wc.hCursor      = 0;
#ifndef Q_OS_WINCE
    wc.hbrBackground = brush;
    if (icon) {
        wc.hIcon = static_cast<HICON>(LoadImage(appInstance, L"IDI_ICON1", IMAGE_ICON, 0, 0, LR_DEFAULTSIZE));
        if (wc.hIcon) {
            int sw = GetSystemMetrics(SM_CXSMICON);
            int sh = GetSystemMetrics(SM_CYSMICON);
            wc.hIconSm = static_cast<HICON>(LoadImage(appInstance, L"IDI_ICON1", IMAGE_ICON, sw, sh, 0));
        } else {
            wc.hIcon = static_cast<HICON>(LoadImage(0, IDI_APPLICATION, IMAGE_ICON, 0, 0, LR_DEFAULTSIZE | LR_SHARED));
            wc.hIconSm = 0;
        }
    } else {
        wc.hIcon    = 0;
        wc.hIconSm  = 0;
    }
#else
    if (icon) {
        wc.hIcon = (HICON)LoadImage(appInstance, L"IDI_ICON1", IMAGE_ICON, 0, 0, LR_DEFAULTSIZE);
    } else {
        wc.hIcon    = 0;
    }
#endif

    wc.lpszMenuName  = 0;
    wc.lpszClassName = reinterpret_cast<LPCWSTR>(cname.utf16());
#ifndef Q_OS_WINCE
    ATOM atom = RegisterClassEx(&wc);
#else
    ATOM atom = RegisterClass(&wc);
#endif

    if (!atom)
        qErrnoWarning("QApplication::regClass: Registering window class '%s' failed.",
                      qPrintable(cname));

    d->m_registeredWindowClassNames.insert(cname);
    qCDebug(lcQpaWindows).nospace() << __FUNCTION__ << ' ' << cname
        << " style=0x" << hex << style << dec
        << " brush=" << brush << " icon=" << icon << " atom=" << atom;
    return cname;
}

void QWindowsContext::unregisterWindowClasses()
{
    const HINSTANCE appInstance = static_cast<HINSTANCE>(GetModuleHandle(0));

    foreach (const QString &name,  d->m_registeredWindowClassNames) {
        if (!UnregisterClass(reinterpret_cast<LPCWSTR>(name.utf16()), appInstance) && QWindowsContext::verbose)
            qErrnoWarning("UnregisterClass failed for '%s'", qPrintable(name));
    }
    d->m_registeredWindowClassNames.clear();
}

int QWindowsContext::screenDepth() const
{
    return GetDeviceCaps(d->m_displayContext, BITSPIXEL);
}

QString QWindowsContext::windowsErrorMessage(unsigned long errorCode)
{
    QString rc = QString::fromLatin1("#%1: ").arg(errorCode);
    ushort *lpMsgBuf;

    const DWORD len = FormatMessage(
            FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
            NULL, errorCode, 0, reinterpret_cast<LPTSTR>(&lpMsgBuf), 0, NULL);
    if (len) {
        rc = QString::fromUtf16(lpMsgBuf, int(len));
        LocalFree(lpMsgBuf);
    } else {
        rc += QString::fromLatin1("<unknown error>");
    }
    return rc;
}

void QWindowsContext::addWindow(HWND hwnd, QWindowsWindow *w)
{
    d->m_windows.insert(hwnd, w);
}

void QWindowsContext::removeWindow(HWND hwnd)
{
    const HandleBaseWindowHash::iterator it = d->m_windows.find(hwnd);
    if (it != d->m_windows.end()) {
        if (d->m_keyMapper.keyGrabber() == it.value()->window())
            d->m_keyMapper.setKeyGrabber(0);
        d->m_windows.erase(it);
    }
}

QWindowsWindow *QWindowsContext::findPlatformWindow(HWND hwnd) const
{
    return d->m_windows.value(hwnd);
}

QWindowsWindow *QWindowsContext::findClosestPlatformWindow(HWND hwnd) const
{
    QWindowsWindow *window = d->m_windows.value(hwnd);

    // Requested hwnd may also be a child of a platform window in case of embedded native windows.
    // Find the closest parent that has a platform window.
    if (!window) {
        for (HWND w = hwnd; w; w = GetParent(w)) {
            window = d->m_windows.value(w);
            if (window)
                break;
        }
    }

    return window;
}

QWindow *QWindowsContext::findWindow(HWND hwnd) const
{
    if (const QWindowsWindow *bw = findPlatformWindow(hwnd))
            return bw->window();
    return 0;
}

QWindow *QWindowsContext::windowUnderMouse() const
{
    return (d->m_systemInfo & QWindowsContext::SI_SupportsPointer) ?
        d->m_pointerHandler.windowUnderMouse() : d->m_mouseHandler.windowUnderMouse();
}

void QWindowsContext::clearWindowUnderMouse()
{
    if (d->m_systemInfo & QWindowsContext::SI_SupportsPointer)
        d->m_pointerHandler.clearWindowUnderMouse();
    else
        d->m_mouseHandler.clearWindowUnderMouse();
}

/*!
    \brief Find a child window at a screen point.

    Deep search for a QWindow at global point, skipping non-owned
    windows (accessibility?). Implemented using ChildWindowFromPointEx()
    instead of (historically used) WindowFromPoint() to get a well-defined
    behaviour for hidden/transparent windows.

    \a cwex_flags are flags of ChildWindowFromPointEx().
    \a parent is the parent window, pass GetDesktopWindow() for top levels.
*/

static inline bool findPlatformWindowHelper(const POINT &screenPoint, unsigned cwexFlags,
                                            const QWindowsContext *context,
                                            HWND *hwnd, QWindowsWindow **result)
{
    POINT point = screenPoint;
    ScreenToClient(*hwnd, &point);
    // Returns parent if inside & none matched.
#ifndef Q_OS_WINCE
    const HWND child = ChildWindowFromPointEx(*hwnd, point, cwexFlags);
#else
//  Under Windows CE we don't use ChildWindowFromPointEx as it's not available
//  and ChildWindowFromPoint does not work properly.
    Q_UNUSED(cwexFlags)
    const HWND child = WindowFromPoint(point);
#endif
    if (!child || child == *hwnd)
        return false;
    if (QWindowsWindow *window = context->findPlatformWindow(child)) {
        *result = window;
        *hwnd = child;
#ifndef Q_OS_WINCE
        return true;
#else
//      WindowFromPoint does not return same handle in two sequential calls, which leads
//      to an endless loop, but calling WindowFromPoint once is good enough.
        return false;
#endif
    }
#ifndef Q_OS_WINCE // Does not have  WS_EX_TRANSPARENT .
    // QTBUG-40555: despite CWP_SKIPINVISIBLE, it is possible to hit on invisible
    // full screen windows of other applications that have WS_EX_TRANSPARENT set
    // (for example created by  screen sharing applications). In that case, try to
    // find a Qt window by searching again with CWP_SKIPTRANSPARENT.
    // Note that Qt 5 uses WS_EX_TRANSPARENT for Qt::WindowTransparentForInput
    // as well.
    if (!(cwexFlags & CWP_SKIPTRANSPARENT)
        && (GetWindowLongPtr(child, GWL_EXSTYLE) & WS_EX_TRANSPARENT)) {
        const HWND nonTransparentChild = ChildWindowFromPointEx(*hwnd, point, cwexFlags | CWP_SKIPTRANSPARENT);
        if (QWindowsWindow *nonTransparentWindow = context->findPlatformWindow(nonTransparentChild)) {
            *result = nonTransparentWindow;
            *hwnd = nonTransparentChild;
            return true;
        }
    }
#endif // !Q_OS_WINCE
    *hwnd = child;
    return true;
}

QWindowsWindow *QWindowsContext::findPlatformWindowAt(HWND parent,
                                                          const QPoint &screenPointIn,
                                                          unsigned cwex_flags) const
{
    QWindowsWindow *result = 0;
    const POINT screenPoint = { screenPointIn.x(), screenPointIn.y() };
    while (findPlatformWindowHelper(screenPoint, cwex_flags, this, &parent, &result)) {}
    return result;
}

QWindowsMimeConverter &QWindowsContext::mimeConverter() const
{
    return d->m_mimeConverter;
}

QWindowsScreenManager &QWindowsContext::screenManager()
{
    return d->m_screenManager;
}

QWindowsTabletSupport *QWindowsContext::tabletSupport() const
{
#if !defined(QT_NO_TABLETEVENT) && !defined(Q_OS_WINCE)
    return d->m_tabletSupport.data();
#else
    return 0;
#endif
}

/*!
    \brief Convenience to create a non-visible, message-only dummy
    window for example used as clipboard watcher or for GL.
*/

HWND QWindowsContext::createDummyWindow(const QString &classNameIn,
                                        const wchar_t *windowName,
                                        WNDPROC wndProc, DWORD style)
{
    if (!wndProc)
        wndProc = DefWindowProc;
    QString className = registerWindowClass(classNameIn, wndProc);
    return CreateWindowEx(0, reinterpret_cast<LPCWSTR>(className.utf16()),
                          windowName, style,
                          CW_USEDEFAULT, CW_USEDEFAULT,
                          CW_USEDEFAULT, CW_USEDEFAULT,
                          HWND_MESSAGE, NULL, static_cast<HINSTANCE>(GetModuleHandle(0)), NULL);
}

#ifndef Q_OS_WINCE
// Re-engineered from the inline function _com_error::ErrorMessage().
// We cannot use it directly since it uses swprintf_s(), which is not
// present in the MSVCRT.DLL found on Windows XP (QTBUG-35617).
static inline QString errorMessageFromComError(const _com_error &comError)
{
     TCHAR *message = Q_NULLPTR;
     FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                   NULL, DWORD(comError.Error()), MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT),
                   message, 0, NULL);
     if (message) {
         const QString result = QString::fromWCharArray(message).trimmed();
         LocalFree(static_cast<HLOCAL>(message));
         return result;
     }
     if (const WORD wCode = comError.WCode())
         return QStringLiteral("IDispatch error #") + QString::number(wCode);
     return QStringLiteral("Unknown error 0x0") + QString::number(comError.Error(), 16);
}
#endif // !Q_OS_WINCE

/*!
    \brief Common COM error strings.
*/

QByteArray QWindowsContext::comErrorString(HRESULT hr)
{
    QByteArray result = QByteArrayLiteral("COM error 0x")
        + QByteArray::number(quintptr(hr), 16) + ' ';
    switch (hr) {
    case S_OK:
        result += QByteArrayLiteral("S_OK");
        break;
    case S_FALSE:
        result += QByteArrayLiteral("S_FALSE");
        break;
    case E_UNEXPECTED:
        result += QByteArrayLiteral("E_UNEXPECTED");
        break;
    case E_ACCESSDENIED:
        result += QByteArrayLiteral("E_ACCESSDENIED");
        break;
    case CO_E_ALREADYINITIALIZED:
        result += QByteArrayLiteral("CO_E_ALREADYINITIALIZED");
        break;
    case CO_E_NOTINITIALIZED:
        result += QByteArrayLiteral("CO_E_NOTINITIALIZED");
        break;
    case RPC_E_CHANGED_MODE:
        result += QByteArrayLiteral("RPC_E_CHANGED_MODE");
        break;
    case OLE_E_WRONGCOMPOBJ:
        result += QByteArrayLiteral("OLE_E_WRONGCOMPOBJ");
        break;
    case CO_E_NOT_SUPPORTED:
        result += QByteArrayLiteral("CO_E_NOT_SUPPORTED");
        break;
    case E_NOTIMPL:
        result += QByteArrayLiteral("E_NOTIMPL");
        break;
    case E_INVALIDARG:
        result += QByteArrayLiteral("E_INVALIDARG");
        break;
    case E_NOINTERFACE:
        result += QByteArrayLiteral("E_NOINTERFACE");
        break;
    case E_POINTER:
        result += QByteArrayLiteral("E_POINTER");
        break;
    case E_HANDLE:
        result += QByteArrayLiteral("E_HANDLE");
        break;
    case E_ABORT:
        result += QByteArrayLiteral("E_ABORT");
        break;
    case E_FAIL:
        result += QByteArrayLiteral("E_FAIL");
        break;
    case RPC_E_WRONG_THREAD:
        result += QByteArrayLiteral("RPC_E_WRONG_THREAD");
        break;
    case RPC_E_THREAD_NOT_INIT:
        result += QByteArrayLiteral("RPC_E_THREAD_NOT_INIT");
        break;
    default:
        break;
    }
#ifndef Q_OS_WINCE
    _com_error error(hr);
    result += QByteArrayLiteral(" (");
    result += errorMessageFromComError(error);
    result += ')';
#endif // !Q_OS_WINCE
    return result;
}

static inline QWindowsInputContext *windowsInputContext()
{
    return qobject_cast<QWindowsInputContext *>(QWindowsIntegration::instance()->inputContext());
}

static inline bool isInputMessage(UINT m)
{
    switch (m) {
    case WM_IME_STARTCOMPOSITION:
    case WM_IME_ENDCOMPOSITION:
    case WM_IME_COMPOSITION:
    case WM_INPUT:
    case WM_TOUCH:
    case WM_MOUSEHOVER:
    case WM_MOUSELEAVE:
    case WM_NCMOUSEHOVER:
    case WM_NCMOUSELEAVE:
    case WM_SIZING:
    case WM_MOVING:
    case WM_SYSCOMMAND:
    case WM_COMMAND:
    case WM_DWMNCRENDERINGCHANGED:
    case WM_PAINT:
        return true;
    default:
        break;
    }
    return (m >= WM_MOUSEFIRST && m <= WM_MOUSELAST)
        || (m >= WM_NCMOUSEMOVE && m <= WM_NCXBUTTONDBLCLK)
        || (m >= WM_KEYFIRST && m <= WM_KEYLAST);
}
/*!
     \brief Main windows procedure registered for windows.

     \sa QWindowsGuiEventDispatcher
*/

bool QWindowsContext::windowsProc(HWND hwnd, UINT message,
                                  QtWindows::WindowsEventType et,
                                  WPARAM wParam, LPARAM lParam,
                                  LRESULT *result,
                                  QWindowsWindow **platformWindowPtr)
{
    *result = 0;

    MSG msg;
    msg.hwnd = hwnd;         // re-create MSG structure
    msg.message = message;   // time and pt fields ignored
    msg.wParam = wParam;
    msg.lParam = lParam;
    msg.pt.x = msg.pt.y = 0;
    if (et != QtWindows::CursorEvent && (et & (QtWindows::MouseEventFlag | QtWindows::NonClientEventFlag))) {
        msg.pt.x = GET_X_LPARAM(lParam);
        msg.pt.y = GET_Y_LPARAM(lParam);
        // For non-client-area messages, these are screen coordinates (as expected
        // in the MSG structure), otherwise they are client coordinates.
        if (!(et & QtWindows::NonClientEventFlag)) {
            ClientToScreen(msg.hwnd, &msg.pt);
        }
    } else {
#ifndef Q_OS_WINCE
        GetCursorPos(&msg.pt);
#endif
    }

    QWindowsWindow *platformWindow = findPlatformWindow(hwnd);
    *platformWindowPtr = platformWindow;

    // Run the native event filters. QTBUG-67095: Exclude input messages which are sent
    // by QEventDispatcherWin32::processEvents()
    if (!isInputMessage(msg.message) && filterNativeEvent(&msg, result))
        return true;

    if (platformWindow && filterNativeEvent(platformWindow->window(), &msg, result))
        return true;
    if (et & QtWindows::InputMethodEventFlag) {
        QWindowsInputContext *windowsInputContext = ::windowsInputContext();
        // Disable IME assuming this is a special implementation hooking into keyboard input.
        // "Real" IME implementations should use a native event filter intercepting IME events.
        if (!windowsInputContext) {
            QWindowsInputContext::setWindowsImeEnabled(platformWindow, false);
            return false;
        }
        switch (et) {
        case QtWindows::InputMethodStartCompositionEvent:
            return windowsInputContext->startComposition(hwnd);
        case QtWindows::InputMethodCompositionEvent:
            return windowsInputContext->composition(hwnd, lParam);
        case QtWindows::InputMethodEndCompositionEvent:
            return windowsInputContext->endComposition(hwnd);
        case QtWindows::InputMethodRequest:
            return windowsInputContext->handleIME_Request(wParam, lParam, result);
        default:
            break;
        }
    } // InputMethodEventFlag

    switch (et) {
    case QtWindows::GestureEvent:
    	if (!(d->m_systemInfo & QWindowsContext::SI_SupportsPointer))
            return sessionManagerInteractionBlocked() || d->m_mouseHandler.translateGestureEvent(platformWindow->window(), hwnd, et, msg, result);
		break;
    case QtWindows::InputMethodOpenCandidateWindowEvent:
    case QtWindows::InputMethodCloseCandidateWindowEvent:
        // TODO: Release/regrab mouse if a popup has mouse grab.
        return false;
    case QtWindows::DestroyEvent:
        if (platformWindow && !platformWindow->testFlag(QWindowsWindow::WithinDestroy)) {
            qWarning() << "External WM_DESTROY received for " << platformWindow->window()
                       << ", parent: " << platformWindow->window()->parent()
                       << ", transient parent: " << platformWindow->window()->transientParent();
            }
        return false;
    case QtWindows::ClipboardEvent:
        return false;
    case QtWindows::UnknownEvent:
        return false;
    case QtWindows::AccessibleObjectFromWindowRequest:
#ifndef QT_NO_ACCESSIBILITY
        return QWindowsAccessibility::handleAccessibleObjectFromWindowRequest(hwnd, wParam, lParam, result);
#else
        return false;
#endif
    case QtWindows::DisplayChangedEvent:
        if (QWindowsTheme *t = QWindowsTheme::instance())
            t->displayChanged();
        return d->m_screenManager.handleDisplayChange(wParam, lParam);
    case QtWindows::SettingChangedEvent:
        return d->m_screenManager.handleScreenChanges();
    default:
        break;
    }

    // Before CreateWindowEx() returns, some events are sent,
    // for example WM_GETMINMAXINFO asking for size constraints for top levels.
    // Pass on to current creation context
    if (!platformWindow && !d->m_creationContext.isNull()) {
        switch (et) {
#ifndef Q_OS_WINCE // maybe available on some SDKs revisit WM_GETMINMAXINFO
        case QtWindows::QuerySizeHints:
            d->m_creationContext->applyToMinMaxInfo(reinterpret_cast<MINMAXINFO *>(lParam));
            return true;
#endif
        case QtWindows::ResizeEvent:
            d->m_creationContext->obtainedGeometry.setSize(QSize(GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam)));
            return true;
        case QtWindows::MoveEvent:
            d->m_creationContext->obtainedGeometry.moveTo(GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
            return true;
        case QtWindows::CalculateSize:
            return QWindowsGeometryHint::handleCalculateSize(d->m_creationContext->customMargins, msg, result);
        case QtWindows::GeometryChangingEvent:
            return QWindowsWindow::handleGeometryChangingMessage(&msg, d->m_creationContext->window,
                                                                 d->m_creationContext->margins + d->m_creationContext->customMargins);
        default:
            break;
        }
    }
    if (platformWindow) {
        // Suppress events sent during DestroyWindow() for native children.
        if (platformWindow->testFlag(QWindowsWindow::WithinDestroy))
            return false;
        if (QWindowsContext::verbose > 1)
            qCDebug(lcQpaEvents) << "Event window: " << platformWindow->window();
    } else {
        qWarning("%s: No Qt Window found for event 0x%x (%s), hwnd=0x%p.",
                 __FUNCTION__, message,
                 QWindowsGuiEventDispatcher::windowsMessageName(message), hwnd);
        return false;
    }

    switch (et) {
    case QtWindows::DeviceChangeEvent:
        if (d->m_systemInfo & QWindowsContext::SI_SupportsTouch)
            break;
        // See if there are any touch devices added
        if (wParam == DBT_DEVNODES_CHANGED)
            initTouch();
        break;
    case QtWindows::KeyboardLayoutChangeEvent:
        if (QWindowsInputContext *wic = windowsInputContext())
            wic->handleInputLanguageChanged(wParam, lParam); // fallthrough intended.
    case QtWindows::KeyDownEvent:
    case QtWindows::KeyEvent:
    case QtWindows::InputMethodKeyEvent:
    case QtWindows::InputMethodKeyDownEvent:
    case QtWindows::AppCommandEvent:
#if !defined(Q_OS_WINCE) && !defined(QT_NO_SESSIONMANAGER)
        return sessionManagerInteractionBlocked() || d->m_keyMapper.translateKeyEvent(platformWindow->window(), hwnd, msg, result);

    case QtWindows::MoveEvent:
        platformWindow->handleMoved();
        return true;
    case QtWindows::ResizeEvent:
        platformWindow->handleResized(static_cast<int>(wParam));
        return true;
#ifndef Q_OS_WINCE // maybe available on some SDKs revisit WM_GETMINMAXINFO
    case QtWindows::QuerySizeHints:
        platformWindow->getSizeHints(reinterpret_cast<MINMAXINFO *>(lParam));
        return true;// maybe available on some SDKs revisit WM_NCCALCSIZE
    case QtWindows::CalculateSize:
        return QWindowsGeometryHint::handleCalculateSize(platformWindow->customMargins(), msg, result);
    case QtWindows::NonClientHitTest:
        return platformWindow->handleNonClientHitTest(QPoint(msg.pt.x, msg.pt.y), result);
    case QtWindows::GeometryChangingEvent:
        return platformWindow->QWindowsWindow::handleGeometryChanging(&msg);
#endif // !Q_OS_WINCE
    case QtWindows::ExposeEvent:
        return platformWindow->handleWmPaint(hwnd, message, wParam, lParam);
    case QtWindows::NonClientMouseEvent:
        if (!(d->m_systemInfo & QWindowsContext::SI_SupportsPointer) && platformWindow->frameStrutEventsEnabled())
            return sessionManagerInteractionBlocked() || d->m_mouseHandler.translateMouseEvent(platformWindow->window(), hwnd, et, msg, result);
        break;
    case QtWindows::NonClientPointerEvent:
        if ((d->m_systemInfo & QWindowsContext::SI_SupportsPointer) && platformWindow->frameStrutEventsEnabled())
            return sessionManagerInteractionBlocked() || d->m_pointerHandler.translatePointerEvent(platformWindow->window(), hwnd, et, msg, result);
        break;
/* the mouse tracking on windows already handles the reset of the cursor
 * and does not like somebody else handling it.
 * on WINCE its necessary to handle this event to get the correct cursor
 */
#ifdef Q_OS_WINCE
    case QtWindows::CursorEvent:
        {
            QWindowsWindow::baseWindowOf(platformWindow->window())->applyCursor();
            return true;
        }
#endif
    case QtWindows::ScrollEvent:
        if (!(d->m_systemInfo & QWindowsContext::SI_SupportsPointer))
            return sessionManagerInteractionBlocked() || d->m_mouseHandler.translateScrollEvent(platformWindow->window(), hwnd, msg, result);
        break;
    case QtWindows::MouseWheelEvent:
    case QtWindows::MouseEvent:
    case QtWindows::LeaveEvent:
	     if (!(d->m_systemInfo & QWindowsContext::SI_SupportsPointer))
            return sessionManagerInteractionBlocked() || d->m_mouseHandler.translateMouseEvent(platformWindow->window(), hwnd, et, msg, result);
		 else 
            return sessionManagerInteractionBlocked() || d->m_pointerHandler.translateMouseEvent(platformWindow->window(), hwnd, et, msg, result);
    case QtWindows::TouchEvent:
        if (!(d->m_systemInfo & QWindowsContext::SI_SupportsPointer))
            return sessionManagerInteractionBlocked() || d->m_mouseHandler.translateTouchEvent(platformWindow->window(), hwnd, et, msg, result);
        break;
    case QtWindows::PointerEvent:
        if (d->m_systemInfo & QWindowsContext::SI_SupportsPointer)
            return sessionManagerInteractionBlocked() || d->m_pointerHandler.translatePointerEvent(platformWindow->window(), hwnd, et, msg, result);
        break;
    case QtWindows::FocusInEvent: // see QWindowsWindow::requestActivateWindow().
    case QtWindows::FocusOutEvent:
        handleFocusEvent(et, platformWindow);
        return true;
    case QtWindows::ShowEventOnParentRestoring: // QTBUG-40696, prevent Windows from re-showing hidden transient children (dialogs).
        if (!platformWindow->window()->isVisible()) {
            *result = 0;
            return true;
        }
        break;
    case QtWindows::HideEvent:
        platformWindow->handleHidden();
        return false;// Indicate transient children should be hidden by windows (SW_PARENTCLOSING)
    case QtWindows::CloseEvent:
        QWindowSystemInterface::handleCloseEvent(platformWindow->window());
        return true;
    case QtWindows::ThemeChanged: {
        // Switch from Aero to Classic changes margins.
        const Qt::WindowFlags flags = platformWindow->window()->flags();
        if ((flags & Qt::WindowType_Mask) != Qt::Desktop && !(flags & Qt::FramelessWindowHint))
            platformWindow->setFlag(QWindowsWindow::FrameDirty);
        if (QWindowsTheme *theme = QWindowsTheme::instance())
            theme->windowsThemeChanged(platformWindow->window());
        return true;
    }
    case QtWindows::CompositionSettingsChanged:
        platformWindow->handleCompositionSettingsChanged();
        return true;
#ifndef Q_OS_WINCE
    case QtWindows::ActivateWindowEvent:
        if (platformWindow->window()->flags() & Qt::WindowDoesNotAcceptFocus) {
            *result = LRESULT(MA_NOACTIVATE);
            return true;
        }
#ifndef QT_NO_TABLETEVENT
        if (!d->m_tabletSupport.isNull())
            d->m_tabletSupport->notifyActivate();
#endif // !QT_NO_TABLETEVENT
        if (platformWindow->testFlag(QWindowsWindow::BlockedByModal))
            if (const QWindow *modalWindow = QGuiApplication::modalWindow())
                QWindowsWindow::baseWindowOf(modalWindow)->alertWindow();
        break;
    case QtWindows::MouseActivateWindowEvent:
    case QtWindows::PointerActivateWindowEvent:
        if (platformWindow->window()->flags() & Qt::WindowDoesNotAcceptFocus) {
            *result = LRESULT(MA_NOACTIVATE);
            return true;
        }
        break;
#endif
#ifndef QT_NO_CONTEXTMENU
    case QtWindows::ContextMenu:
        return handleContextMenuEvent(platformWindow->window(), msg);
#endif
    case QtWindows::WhatsThisEvent: {
#ifndef QT_NO_WHATSTHIS
        QWindowSystemInterface::handleEnterWhatsThisEvent();
        return true;
#endif
    }   break;
#if !defined(Q_OS_WINCE) && !defined(QT_NO_SESSIONMANAGER)
    case QtWindows::QueryEndSessionApplicationEvent: {
        QWindowsSessionManager *sessionManager = platformSessionManager();
        if (sessionManager->isActive()) { // bogus message from windows
            *result = sessionManager->wasCanceled() ? 0 : 1;
            return true;
        }

        sessionManager->setActive(true);
        sessionManager->blocksInteraction();
        sessionManager->clearCancellation();

        QGuiApplicationPrivate *qGuiAppPriv = static_cast<QGuiApplicationPrivate*>(QObjectPrivate::get(qApp));
        qGuiAppPriv->commitData();

        if (lParam & ENDSESSION_LOGOFF)
            fflush(NULL);

        *result = sessionManager->wasCanceled() ? 0 : 1;
        return true;
    }
    case QtWindows::EndSessionApplicationEvent: {
        QWindowsSessionManager *sessionManager = platformSessionManager();

        sessionManager->setActive(false);
        sessionManager->allowsInteraction();
        const bool endsession = wParam != 0;

        // we receive the message for each toplevel window included internal hidden ones,
        // but the aboutToQuit signal should be emitted only once.
        QGuiApplicationPrivate *qGuiAppPriv = static_cast<QGuiApplicationPrivate*>(QObjectPrivate::get(qApp));
        if (endsession && !qGuiAppPriv->aboutToQuitEmitted) {
            qGuiAppPriv->aboutToQuitEmitted = true;
            int index = QGuiApplication::staticMetaObject.indexOfSignal("aboutToQuit()");
            qApp->qt_metacall(QMetaObject::InvokeMetaMethod, index,0);
            // since the process will be killed immediately quit() has no real effect
            QGuiApplication::quit();
        }
        return true;
    }
#endif // !defined(Q_OS_WINCE) && !defined(QT_NO_SESSIONMANAGER)
    default:
        break;
    }
    return false;
}

/* Compress activation events. If the next focus window is already known
 * at the time the current one receives focus-out, pass that to
 * QWindowSystemInterface instead of sending 0 and ignore its consecutive
 * focus-in event.
 * This helps applications that do handling in focus-out events. */
void QWindowsContext::handleFocusEvent(QtWindows::WindowsEventType et,
                                       QWindowsWindow *platformWindow)
{
    QWindow *nextActiveWindow = 0;
    if (et == QtWindows::FocusInEvent) {
        QWindow *topWindow = QWindowsWindow::topLevelOf(platformWindow->window());
        QWindow *modalWindow = 0;
        if (QGuiApplicationPrivate::instance()->isWindowBlocked(topWindow, &modalWindow) && topWindow != modalWindow) {
            modalWindow->requestActivate();
            return;
        }
        // QTBUG-32867: Invoking WinAPI SetParent() can cause focus-in for the
        // window which is not desired for native child widgets.
        if (platformWindow->testFlag(QWindowsWindow::WithinSetParent)) {
            QWindow *currentFocusWindow = QGuiApplication::focusWindow();
            if (currentFocusWindow && currentFocusWindow != platformWindow->window()) {
                currentFocusWindow->requestActivate();
                return;
            }
        }
        nextActiveWindow = platformWindow->window();
    } else {
        // Focus out: Is the next window known and different
        // from the receiving the focus out.
        if (const HWND nextActiveHwnd = GetFocus())
            if (QWindowsWindow *nextActivePlatformWindow = findClosestPlatformWindow(nextActiveHwnd))
                if (nextActivePlatformWindow != platformWindow)
                    nextActiveWindow = nextActivePlatformWindow->window();
    }
    if (nextActiveWindow != d->m_lastActiveWindow) {
         d->m_lastActiveWindow = nextActiveWindow;
         QWindowSystemInterface::handleWindowActivated(nextActiveWindow);
    }
}

#ifndef QT_NO_CONTEXTMENU
bool QWindowsContext::handleContextMenuEvent(QWindow *window, const MSG &msg)
{
    bool mouseTriggered = false;
    QPoint globalPos;
    QPoint pos;
    if (msg.lParam != int(0xffffffff)) {
        mouseTriggered = true;
        globalPos.setX(msg.pt.x);
        globalPos.setY(msg.pt.y);
        pos = QWindowsGeometryHint::mapFromGlobal(msg.hwnd, globalPos);

        RECT clientRect;
        if (GetClientRect(msg.hwnd, &clientRect)) {
            if (pos.x() < clientRect.left || pos.x() >= clientRect.right ||
                pos.y() < clientRect.top || pos.y() >= clientRect.bottom)
            {
                // This is the case that user has right clicked in the window's caption,
                // We should call DefWindowProc() to display a default shortcut menu
                // instead of sending a Qt window system event.
                return false;
            }
        }
    }

    QWindowSystemInterface::handleContextMenuEvent(window, mouseTriggered, pos, globalPos,
                                                   QWindowsKeyMapper::queryKeyboardModifiers());
    return true;
}
#endif

bool QWindowsContext::asyncExpose() const
{
    return d->m_asyncExpose;
}

void QWindowsContext::setAsyncExpose(bool value)
{
    d->m_asyncExpose = value;
}

QTouchDevice *QWindowsContext::touchDevice() const
{
    return (d->m_systemInfo & QWindowsContext::SI_SupportsPointer) ?
        d->m_pointerHandler.touchDevice() : d->m_mouseHandler.touchDevice();
}

static DWORD readDwordRegistrySetting(const wchar_t *regKey, const wchar_t *subKey, DWORD defaultValue)
{
    DWORD result = defaultValue;
    HKEY handle;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, regKey, 0, KEY_READ, &handle) == ERROR_SUCCESS) {
        DWORD type;
        if (RegQueryValueEx(handle, subKey, 0, &type, 0, 0) == ERROR_SUCCESS && type == REG_DWORD) {
            DWORD value;
            DWORD size = sizeof(result);
            if (RegQueryValueEx(handle, subKey, 0, 0, reinterpret_cast<unsigned char *>(&value), &size) == ERROR_SUCCESS)
                result = value;
        }
        RegCloseKey(handle);
    }
    return result;
}

DWORD QWindowsContext::readAdvancedExplorerSettings(const wchar_t *subKey, DWORD defaultValue)
{
    return readDwordRegistrySetting(L"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
                                    subKey, defaultValue);
}

static inline bool isEmptyRect(const RECT &rect)
{
    return rect.right - rect.left == 0 && rect.bottom - rect.top == 0;
}

static inline QMargins marginsFromRects(const RECT &frame, const RECT &client)
{
    return QMargins(client.left - frame.left, client.top - frame.top,
                    frame.right - client.right, frame.bottom - client.bottom);
}

static RECT rectFromNcCalcSize(UINT message, WPARAM wParam, LPARAM lParam, int n)
{
    RECT result = {0, 0, 0, 0};
    if (message == WM_NCCALCSIZE && wParam)
        result = reinterpret_cast<const NCCALCSIZE_PARAMS *>(lParam)->rgrc[n];
    return result;
}

static inline bool isMinimized(HWND hwnd)
{
    WINDOWPLACEMENT windowPlacement;
    windowPlacement.length = sizeof(WINDOWPLACEMENT);
    return GetWindowPlacement(hwnd, &windowPlacement) && windowPlacement.showCmd == SW_SHOWMINIMIZED;
}

static inline bool isTopLevel(HWND hwnd)
{
    return (GetWindowLongPtr(hwnd, GWL_STYLE) & WS_CHILD) == 0;
}

/*!
    \brief Windows functions for actual windows.

    There is another one for timers, sockets, etc in
    QEventDispatcherWin32.

    \ingroup qt-lighthouse-win
*/

extern "C" LRESULT QT_WIN_CALLBACK qWindowsWndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    LRESULT result;
    const QtWindows::WindowsEventType et = windowsEventType(message, wParam, lParam);
    QWindowsWindow *platformWindow = nullptr;
    const RECT ncCalcSizeFrame = rectFromNcCalcSize(message, wParam, lParam, 0);
    const bool handled = QWindowsContext::instance()->windowsProc(hwnd, message, et, wParam, lParam, &result, &platformWindow);
    if (QWindowsContext::verbose > 1 && lcQpaEvents().isDebugEnabled()) {
        if (const char *eventName = QWindowsGuiEventDispatcher::windowsMessageName(message)) {
            qCDebug(lcQpaEvents).nospace() << "EVENT: hwd=" << hwnd << ' ' << eventName
                << " msg=0x" << hex << message << " et=0x" << et << dec << " wp="
                << int(wParam) << " at " << GET_X_LPARAM(lParam) << ','
                << GET_Y_LPARAM(lParam) << " handled=" << handled;
        }
    }
    if (!handled)
        result = DefWindowProc(hwnd, message, wParam, lParam);

    // Capture WM_NCCALCSIZE on top level windows and obtain the window margins by
    // subtracting the rectangles before and after processing. This will correctly
    // capture client code overriding the message and allow for per-monitor margins
    // for High DPI (QTBUG-53255, QTBUG-40578).
    if (message == WM_NCCALCSIZE && !isEmptyRect(ncCalcSizeFrame) && isTopLevel(hwnd) && !isMinimized(hwnd)) {
        const QMargins margins =
            marginsFromRects(ncCalcSizeFrame, rectFromNcCalcSize(message, wParam, lParam, 0));
        if (margins.left() >= 0) {
            if (platformWindow) {
                platformWindow->setFullFrameMargins(margins);
            } else {
                const QSharedPointer<QWindowCreationContext> ctx = QWindowsContext::instance()->windowCreationContext();
                if (!ctx.isNull())
                    ctx->margins = margins;
            }
        }
    }
    return result;
}


static inline QByteArray nativeEventType() { return QByteArrayLiteral("windows_generic_MSG"); }

// Send to QAbstractEventDispatcher
bool QWindowsContext::filterNativeEvent(MSG *msg, LRESULT *result)
{
    QAbstractEventDispatcher *dispatcher = QAbstractEventDispatcher::instance();
    long filterResult = 0;
    if (dispatcher && dispatcher->filterNativeEvent(nativeEventType(), msg, &filterResult)) {
        *result = LRESULT(filterResult);
        return true;
    }
    return false;
}

// Send to QWindowSystemInterface
bool QWindowsContext::filterNativeEvent(QWindow *window, MSG *msg, LRESULT *result)
{
    long filterResult = 0;
    if (QWindowSystemInterface::handleNativeEvent(window, nativeEventType(), msg, &filterResult)) {
        *result = LRESULT(filterResult);
        return true;
    }
    return false;
}

QT_END_NAMESPACE
