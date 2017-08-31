import qbs
import qbs.FileInfo

CppApplication {
    name: "completer"
    condition: Qt.widgets.present && Qt.widgets.config.completer

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "completer.qrc",
        "fsmodel.cpp",
        "fsmodel.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "completer")
    }
}
