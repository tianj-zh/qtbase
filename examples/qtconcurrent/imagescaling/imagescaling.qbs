import qbs
import qbs.FileInfo

CppApplication {
    name: "imagescaling"
    condition: Qt.concurrent.present && Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.concurrent"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "imagescaling.cpp",
        "imagescaling.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "qtconcurrent",
                                           "imagescaling")
    }
}
