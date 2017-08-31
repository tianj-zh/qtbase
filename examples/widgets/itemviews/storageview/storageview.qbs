import qbs
import qbs.FileInfo

CppApplication {
    name: "storageview"
    condition: Qt.widgets.present && Qt.widgets.config.treeview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "storagemodel.cpp",
        "storagemodel.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "storageview")
    }
}
