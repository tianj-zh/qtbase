import qbs
import qbs.FileInfo

CppApplication {
    name: "dockwidgets"
    condition: Qt.widgets.present && Qt.gui.config.cursor && Qt.widgets.config.listwidget

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "dockwidgets.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "mainwindows",
                                           "dockwidgets")
    }
}
