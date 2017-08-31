import qbs
import qbs.FileInfo

CppApplication {
    name: "threadedfortuneserver"
    condition: Qt.network.present && Qt.widgets.present

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "dialog.cpp",
        "dialog.h",
        "fortuneserver.cpp",
        "fortuneserver.h",
        "fortunethread.cpp",
        "fortunethread.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network",
                                           "threadedfortuneserver")
    }
}
