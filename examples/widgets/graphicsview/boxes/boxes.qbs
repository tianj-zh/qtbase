import qbs
import qbs.FileInfo

CppApplication {
    name: "boxes"
    condition: Qt.opengl.present && Qt.widgets.present
        && !Qt.gui.config.opengles2 && !Qt.gui.config.opengles3
        && !Qt.gui.config.opengles31 && !Qt.gui.config.opengles32
        && !Qt.gui.config.angle && !Qt.gui.config.dynamicgl
        && Qt.widgets.config.combobox

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.opengl"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "3rdparty/fbm.c",
        "3rdparty/fbm.h",
        "boxes.qrc",
        "glbuffers.cpp",
        "glbuffers.h",
        "glextensions.cpp",
        "glextensions.h",
        "gltrianglemesh.h",
        "main.cpp",
        "qtbox.cpp",
        "qtbox.h",
        "roundedbox.cpp",
        "roundedbox.h",
        "scene.cpp",
        "scene.h",
        "trackball.cpp",
        "trackball.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "boxes")
    }
}
