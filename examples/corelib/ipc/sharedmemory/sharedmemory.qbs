import qbs
import qbs.FileInfo

CppApplication {
    name: "sharedmemory"
    condition: Qt.widgets.present && !qbs.targetOS.contains("vxworks")
               && Qt.core.config.sharedmemory && Qt.widgets.config.filedialog

    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "dialog.cpp",
        "dialog.h",
        "dialog.ui",
        "main.cpp",
        "*.png",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "ipc", "sharedmemory")
    }
}
