import qbs
import qbs.FileInfo

CppApplication {
    name: "multicastsender"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.udpsocket

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "sender.cpp",
        "sender.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "multicastsender")
    }
}
