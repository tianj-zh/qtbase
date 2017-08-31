import qbs
import qbs.FileInfo

CppApplication {
    name: "editabletreemodel"
    condition: Qt.widgets.present && Qt.widgets.config.treeview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "editabletreemodel.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "mainwindow.ui",
        "treeitem.cpp",
        "treeitem.h",
        "treemodel.cpp",
        "treemodel.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "editabletreemodel")
    }
}
