import qbs
import qbs.FileInfo

CppApplication {
    name: "mandelbrot"
    condition: Qt.widgets.present
    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "main.cpp",
        "mandelbrotwidget.cpp",
        "mandelbrotwidget.h",
        "renderthread.cpp",
        "renderthread.h",
    ]
    Properties {
        condition: qbs.targetOS.contains("unix")
                       && !qbs.targetOS.containsAny(["darwin", "vxworks", "integrity", "haiku"])
        cpp.dynamicLibraries: base.concat("m")
    }
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "threads", "mandelbrot")
    }
}
