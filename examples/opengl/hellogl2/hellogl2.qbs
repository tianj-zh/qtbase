import qbs
import qbs.FileInfo

CppApplication {
    name: "hellogl2"
    condition: Qt.widgets.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "glwidget.cpp",
        "glwidget.h",
        "logo.cpp",
        "logo.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "hellogl2")
    }
}
