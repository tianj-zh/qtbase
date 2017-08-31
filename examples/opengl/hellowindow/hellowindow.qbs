import qbs
import qbs.FileInfo

CppApplication {
    name: "hellowindow"
    condition: Qt.gui.present && Qt.gui.config.opengl

    Depends { name: "Qt.core-private" }
    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.gui-private"; required: false }

    files: [
        "hellowindow.cpp",
        "hellowindow.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "opengl", "hellowindow")
    }
}
