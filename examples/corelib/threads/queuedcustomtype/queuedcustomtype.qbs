import qbs
import qbs.FileInfo

CppApplication {
    condition: Qt.widgets.present && Qt.widgets.config.filedialog
    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "block.cpp",
        "block.h",
        "main.cpp",
        "renderthread.cpp",
        "renderthread.h",
        "window.cpp",
        "window.h",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "threads", "queuedcustomtype")
    }
}
