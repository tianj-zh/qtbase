import qbs
import qbs.FileInfo

CppApplication {
    name: "undo"
    condition: Qt.widgets.present && Qt.widgets.config.undoview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "commands.cpp",
        "commands.h",
        "document.cpp",
        "document.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "mainwindow.ui",
        "undo.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "undo")
    }
}
