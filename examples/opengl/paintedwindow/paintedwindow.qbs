import qbs
import qbs.FileInfo

CppApplication {
    name: "paintedwindow"
    condition: Qt.gui.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }

    files: [
        "main.cpp",
        "paintedwindow.cpp",
        "paintedwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "paintedwindow")
    }
}
