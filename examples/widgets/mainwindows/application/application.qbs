import qbs
import qbs.FileInfo

CppApplication {
    name: "application"
    condition: Qt.widgets.present && Qt.gui.config.cursor && Qt.widgets.config.filedialog

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "application.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "mainwindows",
                                           "application")
    }
}
