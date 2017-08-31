import qbs
import qbs.FileInfo

CppApplication {
    name: "dynamiclayouts"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "dialog.cpp",
        "dialog.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "layouts",
                                           "dynamiclayouts")
    }
}
