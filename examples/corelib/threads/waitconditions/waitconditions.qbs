import qbs
import qbs.FileInfo

CppApplication {
    name: "waitconditions"
    Depends { name: "Qt.core" }
    consoleApplication: true
    files: [
        "waitconditions.cpp",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "threads", "waitconditions")
    }
}
