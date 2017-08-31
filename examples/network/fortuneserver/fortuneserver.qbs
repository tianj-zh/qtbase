import qbs
import qbs.FileInfo

CppApplication {
    name: "fortuneserver"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.bearermanagement

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "server.cpp",
        "server.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "fortuneserver")
    }
}
