import qbs
import qbs.FileInfo

CppApplication {
    name: "cube"
    condition: Qt.widgets.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "geometryengine.cpp",
        "geometryengine.h",
        "main.cpp",
        "mainwidget.cpp",
        "mainwidget.h",
        "shaders.qrc",
        "textures.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "cube")
    }
}
