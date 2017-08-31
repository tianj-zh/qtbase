import qbs
import qbs.FileInfo

CppApplication {
    name: "treemodelcompleter"
    condition: Qt.widgets.present && Qt.widgets.config.completer

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "treemodelcompleter.cpp",
        "treemodelcompleter.h",
        "treemodelcompleter.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "treemodelcompleter")
    }
}
