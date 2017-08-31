import qbs
import qbs.FileInfo

CppApplication {
    name: "qopenglwindow"
    condition: Qt.gui.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }

    cpp.includePaths: base.concat(".")

    files: [
        "background_renderer.cpp",
        "background_renderer.h",
        "main.cpp",
        "shaders.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "qopenglwindow")
    }
}
