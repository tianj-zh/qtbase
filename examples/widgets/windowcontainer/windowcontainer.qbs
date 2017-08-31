import qbs
import qbs.FileInfo

CppApplication {
    name: "windowcontainer"
    condition: Qt.widgets.present && (Qt.gui.config.opengl || Qt.gui.config.opengles2)

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    cpp.includePaths: base.concat("../../gui/openglwindow")

    files: [
        "windowcontainer.cpp",
    ]

    Group {
        name: "sources from openglwindow"
        prefix: "../../gui/openglwindow/"
        files: [
            "openglwindow.cpp",
            "openglwindow.h",
        ]
    }

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets",
                                            "windowcontainer")
    }
}
