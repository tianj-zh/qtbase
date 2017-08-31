import qbs

CppApplication {
    name: "openglwindow"
    condition: Qt.gui.present && (Qt.gui.config.opengl || Qt.gui.config.opengles2)
    Depends { name: "Qt.gui"; required: false }
    cpp.includePaths: base.concat(".")
    files: [
        "main.cpp",
        "openglwindow.cpp",
        "openglwindow.h",
    ]
}
