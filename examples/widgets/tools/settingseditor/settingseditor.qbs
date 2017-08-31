import qbs
import qbs.FileInfo

CppApplication {
    name: "settingseditor"
    condition: Qt.widgets.present && Qt.widgets.config.tablewidget

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "locationdialog.cpp",
        "locationdialog.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "settingstree.cpp",
        "settingstree.h",
        "variantdelegate.cpp",
        "variantdelegate.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "settingseditor")
    }
}
