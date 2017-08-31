import qbs
import qbs.FileInfo

CppApplication {
    name: "fontsampler"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "mainwindowbase.ui",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "fontsampler")
    }
}
