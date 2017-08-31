import qbs
import qbs.FileInfo

CppApplication {
    name: "orderform"
    condition: Qt.widgets.present && Qt.widgets.config.tablewidget

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "detailsdialog.cpp",
        "detailsdialog.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "richtext",
                                           "orderform")
    }
}
