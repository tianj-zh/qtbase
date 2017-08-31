import qbs
import qbs.FileInfo

CppApplication {
    name: "nestedlayouts"
    condition: Qt.widgets.present && Qt.widgets.config.tableview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tutorials",
                                           "widgets", "nestedlayouts")
    }
}
