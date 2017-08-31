import qbs
import qbs.FileInfo

CppApplication {
    name: "qopenglwidget"
    condition: Qt.widgets.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "bubble.cpp",
        "bubble.h",
        "glwidget.cpp",
        "glwidget.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "texture.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "qopenglwidget")
    }
}
