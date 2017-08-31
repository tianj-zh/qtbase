import qbs
import qbs.FileInfo

CppApplication {
    name: "tabdialog"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "tabdialog.cpp",
        "tabdialog.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "dialogs",
                                           "tabdialog")
    }
}
