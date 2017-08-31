import qbs
import qbs.FileInfo

CppApplication {
    name: "localfortuneclient"
    condition: Qt.network.present && Qt.widgets.present
    Depends { name: "Qt.core" }
    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "client.cpp",
        "client.h",
        "main.cpp",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "ipc", "localfortuneclient")
    }
}
