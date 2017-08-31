import qbs
import qbs.FileInfo

CppApplication {
    name: "hellogles3"
    condition: Qt.gui.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }

    files: [
        "../hellogl2/logo.cpp",
        "../hellogl2/logo.h",
        "glwindow.cpp",
        "glwindow.h",
        "hellogles3.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "hellogles3")
    }
}
