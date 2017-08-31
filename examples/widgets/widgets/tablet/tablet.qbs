import qbs
import qbs.FileInfo

CppApplication {
    name: "tablet"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "images.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "tabletapplication.cpp",
        "tabletapplication.h",
        "tabletcanvas.cpp",
        "tabletcanvas.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "tablet")
    }
}
