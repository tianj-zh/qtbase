import qbs
import qbs.FileInfo

CppApplication {
    name: "mainwindow"
    condition: Qt.widgets.present && Qt.gui.config.cursor && Qt.widgets.config.combobox

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "colorswatch.cpp",
        "colorswatch.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "mainwindow.qrc",
        "toolbar.cpp",
        "toolbar.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "mainwindows",
                                           "mainwindow")
    }
}
