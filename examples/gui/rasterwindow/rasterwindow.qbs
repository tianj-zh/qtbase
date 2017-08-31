import qbs
import qbs.FileInfo

CppApplication {
    name: "rasterwindow"
    condition: Qt.gui.present
    Depends { name: "Qt.gui"; required: false }
    cpp.includePaths: base.concat(".")
    files: [
        "main.cpp",
        "rasterwindow.cpp",
        "rasterwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "gui", "rasterwindow")
    }
}
