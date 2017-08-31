import qbs
import qbs.FileInfo

CppApplication {
    name: "addressbook"
    condition: Qt.widgets.present && Qt.widgets.config.listview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "adddialog.cpp",
        "adddialog.h",
        "addresswidget.cpp",
        "addresswidget.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "newaddresstab.cpp",
        "newaddresstab.h",
        "tablemodel.cpp",
        "tablemodel.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "addressbook")
    }
}
