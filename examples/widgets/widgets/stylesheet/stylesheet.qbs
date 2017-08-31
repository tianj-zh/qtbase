import qbs
import qbs.FileInfo

CppApplication {
    name: "stylesheet"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "mainwindow.ui",
        "stylesheet.qrc",
        "stylesheeteditor.cpp",
        "stylesheeteditor.h",
        "stylesheeteditor.ui",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "stylesheet")
    }
}
