import qbs
import qbs.FileInfo

CppApplication {
    name: "syntaxhighlighter"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "highlighter.cpp",
        "highlighter.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "richtext",
                                           "syntaxhighlighter")
    }
}
