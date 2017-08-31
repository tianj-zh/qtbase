import qbs
import qbs.FileInfo

CppApplication {
    name: "scribble"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "scribblearea.cpp",
        "scribblearea.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "scribble")
    }
}
