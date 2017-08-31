import qbs
import qbs.FileInfo

CppApplication {
    name: "frozencolumn"
    condition: Qt.widgets.present && Qt.widgets.config.tableview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "freezetablewidget.cpp",
        "freezetablewidget.h",
        "grades.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "frozencolumn")
    }
}
