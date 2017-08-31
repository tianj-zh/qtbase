import qbs
import qbs.FileInfo

CppApplication {
    name: "spreadsheet"
    condition: Qt.widgets.present && Qt.widgets.config.treeview

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "printview.cpp",
        "printview.h",
        "spreadsheet.cpp",
        "spreadsheet.h",
        "spreadsheet.qrc",
        "spreadsheetdelegate.cpp",
        "spreadsheetdelegate.h",
        "spreadsheetitem.cpp",
        "spreadsheetitem.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "spreadsheet")
    }
}
