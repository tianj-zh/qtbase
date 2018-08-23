import qbs

QtModuleProject {
    name: "QtEventDispatcherSupport"
    simpleName: "eventdispatcher_support"
    internal: true

    QtHeaders {
    }

    QtModule {
        qbsSearchPaths: [project.qtbaseShadowDir + "/src/corelib/qbs"]

        Export {
            Depends { name: "cpp" }
            Depends { name: "Qt.core" }
            cpp.includePaths: project.includePaths
        }

        Depends { name: project.headersName }
        Depends { name: "Qt.core_private" }
        Depends { name: "Qt.gui_private" }
        Depends { name: "Glib"; condition: Qt.core_private.config.glib }

        cpp.includePaths: project.includePaths.concat(base)
        cpp.defines: base.concat("QT_NO_CAST_FROM_ASCII")

        Group {
            condition: qbs.targetOS.contains("unix")
            files: [
                "qgenericunixeventdispatcher.cpp",
                "qgenericunixeventdispatcher_p.h",
                "qunixeventdispatcher.cpp",
                "qunixeventdispatcher_qpa_p.h",
            ]
        }
        Group {
            condition: qbs.targetOS.contains("windows")
            files: [
                "qwindowsguieventdispatcher.cpp",
                "qwindowsguieventdispatcher_p.h",
            ]
        }
        Group {
            condition: Qt.core_private.config.glib
            files: [
                "qeventdispatcher_glib.cpp",
                "qeventdispatcher_glib_p.h",
            ]
        }
        Group {
            name: "Qt.core precompiled header"
            files: ["../../corelib/global/qt_pch.h"]
        }
    }
}