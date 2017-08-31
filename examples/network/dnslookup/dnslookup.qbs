import qbs
import qbs.FileInfo

CppApplication {
    name: "dnslookup"
    condition: Qt.network.present
    consoleApplication: true

    Depends { name: "Qt.network"; required: false }

    files: [
        "dnslookup.cpp",
        "dnslookup.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "dnslookup")
    }
}
