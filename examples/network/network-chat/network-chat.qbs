import qbs
import qbs.FileInfo

CppApplication {
    name: "network-chat"
    condition: Qt.network.present && Qt.widgets.present && Qt.core.config.processenvironment
               && Qt.network.config.bearermanagement && Qt.network.config.udpsocket
               && Qt.widgets.config.listwidget

    Depends { name: "Qt.core" }
    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "chatdialog.cpp",
        "chatdialog.h",
        "chatdialog.ui",
        "client.cpp",
        "client.h",
        "connection.cpp",
        "connection.h",
        "main.cpp",
        "peermanager.cpp",
        "peermanager.h",
        "server.cpp",
        "server.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "network-chat")
    }
}
