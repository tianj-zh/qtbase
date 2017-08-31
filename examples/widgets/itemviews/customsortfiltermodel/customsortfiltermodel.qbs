import qbs
import qbs.FileInfo

CppApplication {
    name: "customsortfiltermodel"
    condition: Qt.widgets.present && Qt.widgets.config.treeview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "customsortfiltermodel.qrc",
        "filterwidget.cpp",
        "filterwidget.h",
        "main.cpp",
        "mysortfilterproxymodel.cpp",
        "mysortfilterproxymodel.h",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "customsortfiltermodel")
    }
}
