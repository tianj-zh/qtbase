import qbs
import qbs.FileInfo

CppApplication {
    name: "chat"
    condition: Qt.dbus.present && Qt.widgets.present

    Depends { name: "Qt.dbus"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "chat.cpp",
        "chat.h",
        "chatmainwindow.ui",
        "chatsetnickname.ui",
    ]

    Group {
        name: "xml file"
        files: ["org.example.chat.xml"]
        fileTags: ["qt.dbus.adaptor", "qt.dbus.interface"]
    }

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "dbus", "chat")
    }
}
