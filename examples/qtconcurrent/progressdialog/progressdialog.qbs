import qbs
import qbs.FileInfo

CppApplication {
    name: "progressdialog"
    condition: Qt.concurrent.present && Qt.widgets.present
    consoleApplication: true

    Depends { name: "Qt.concurrent"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "qtconcurrent",
                                           "progressdialog")
    }
}
