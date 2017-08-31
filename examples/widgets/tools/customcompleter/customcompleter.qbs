import qbs
import qbs.FileInfo

CppApplication {
    name: "customcompleter"
    condition: Qt.widgets.present && Qt.widgets.config.completer

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "customcompleter.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "textedit.cpp",
        "textedit.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "customcompleter")
    }
}
