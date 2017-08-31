import qbs
import qbs.FileInfo

CppApplication {
    name: "analogclock"
    condition: Qt.gui.present
    Depends { name: "Qt.gui"; required: false }
    cpp.includePaths: base.concat("../rasterwindow")
    files: [
        "../rasterwindow/rasterwindow.cpp",
        "../rasterwindow/rasterwindow.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "gui", "analogclock")
    }
}
