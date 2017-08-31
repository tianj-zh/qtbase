import qbs
import qbs.FileInfo

CppApplication {
    name: "localfortuneserver"
    condition: Qt.network.present && Qt.widgets.present
    Depends { name: "Qt.core" }
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
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "ipc", "localfortuneserver")
    }
}
