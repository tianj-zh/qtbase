import qbs
import qbs.FileInfo

CppApplication {
    name: "semaphores"
    consoleApplication: true
    Depends { name: "Qt.core" }
    files: [
        "semaphores.cpp",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "threads", "semaphores")
    }
}
