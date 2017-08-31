import qbs
import qbs.FileInfo

CppApplication {
    name: "simpletreemodel"
    condition: Qt.widgets.present && Qt.widgets.config.treeview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "simpletreemodel.qrc",
        "treeitem.cpp",
        "treeitem.h",
        "treemodel.cpp",
        "treemodel.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "simpletreemodel")
    }
}
