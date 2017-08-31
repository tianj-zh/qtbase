import qbs
import qbs.FileInfo

CppApplication {
    name: "undoframework"
    condition: Qt.widgets.present && Qt.widgets.config.undoview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "commands.cpp",
        "commands.h",
        "diagramitem.cpp",
        "diagramitem.h",
        "diagramscene.cpp",
        "diagramscene.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "undoframework.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "undoframework")
    }
}
