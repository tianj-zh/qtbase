import qbs
import qbs.FileInfo

CppApplication {
    name: "elidedlabel"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "elidedlabel.cpp",
        "elidedlabel.h",
        "main.cpp",
        "testwidget.cpp",
        "testwidget.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "elidedlabel")
    }
}
