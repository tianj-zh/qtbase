import qbs
import qbs.FileInfo

CppApplication {
    name: "contextinfo"
    condition: Qt.widgets.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "renderwindow.cpp",
        "renderwindow.h",
        "widget.cpp",
        "widget.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "contextinfo")
    }
}
