import qbs
import qbs.FileInfo

CppApplication {
    name: "itemviewpuzzle"
    targetName: "puzzle"
    condition: Qt.widgets.present && Qt.gui.config.draganddrop && Qt.widgets.config.listview

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "piecesmodel.cpp",
        "piecesmodel.h",
        "puzzle.qrc",
        "puzzlewidget.cpp",
        "puzzlewidget.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "puzzle")
    }
}
