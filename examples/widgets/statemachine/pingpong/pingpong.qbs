import qbs
import qbs.FileInfo

CppApplication {
    name: "pingpong"
    consoleApplication: true

    Depends { name: "Qt.core" }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "statemachine",
                                           "pingpong")
    }
}
