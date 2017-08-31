import qbs
import qbs.FileInfo

CppApplication {
    name: "downloadmanager"
    condition: Qt.network.present
    consoleApplication: true

    Depends { name: "Qt.network"; required: false }

    files: [
        "downloadmanager.cpp",
        "downloadmanager.h",
        "main.cpp",
        "textprogressbar.cpp",
        "textprogressbar.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "downloadmanager")
    }
}
