import qbs
import qbs.FileInfo

CppApplication {
    name: "download"
    condition: Qt.network.present
    consoleApplication: true

    Depends { name: "Qt.network"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "download")
    }
}
