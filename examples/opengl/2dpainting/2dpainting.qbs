import qbs
import qbs.FileInfo

CppApplication {
    name: "2dpainting"
    condition: Qt.widgets.present && Qt.gui.config.opengl

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "glwidget.cpp",
        "glwidget.h",
        "helper.cpp",
        "helper.h",
        "main.cpp",
        "widget.cpp",
        "widget.h",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "2dpainting")
    }
}
