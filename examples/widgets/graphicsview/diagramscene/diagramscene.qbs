import qbs
import qbs.FileInfo

CppApplication {
    name: "diagramscene"
    condition: Qt.widgets.present && Qt.widgets.config.fontcombobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "arrow.cpp",
        "arrow.h",
        "diagramitem.cpp",
        "diagramitem.h",
        "diagramscene.cpp",
        "diagramscene.h",
        "diagramscene.qrc",
        "diagramtextitem.cpp",
        "diagramtextitem.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "diagramscene")
    }
}
