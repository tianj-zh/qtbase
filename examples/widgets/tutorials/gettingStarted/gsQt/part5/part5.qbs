import qbs
import qbs.FileInfo

CppApplication {
    name: "gettingStarted_part5"
    targetName: "part5"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tutorials",
                                           "gettingStarted", "gsQt", "part5")
    }
}
