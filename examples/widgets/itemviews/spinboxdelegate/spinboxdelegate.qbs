import qbs
import qbs.FileInfo

CppApplication {
    name: "spinboxdelegate"
    condition: Qt.widgets.present && Qt.widgets.config.tableview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "delegate.cpp",
        "delegate.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "spinboxdelegate")
    }
}
