import qbs
import qbs.FileInfo

CppApplication {
    name: "mv_edit"
    condition: Qt.widgets.present && Qt.widgets.config.tableview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "mymodel.cpp",
        "mymodel.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tutorials",
                                           "modelview", "5_edit")
    }
}
