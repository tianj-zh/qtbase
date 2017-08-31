import qbs
import qbs.FileInfo

CppApplication {
    name: "draganddroppuzzle"
    targetName: "puzzle"
    condition: Qt.widgets.present && Qt.gui.config.draganddrop
        && Qt.widgets.config.filedialog

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "pieceslist.cpp",
        "pieceslist.h",
        "puzzle.qrc",
        "puzzlewidget.cpp",
        "puzzlewidget.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "draganddrop",
                                           "puzzle")
    }
}
