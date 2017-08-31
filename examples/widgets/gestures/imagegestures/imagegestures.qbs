import qbs
import qbs.FileInfo

CppApplication {
    name: "imagegestures"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "imagewidget.cpp",
        "imagewidget.h",
        "main.cpp",
        "mainwidget.cpp",
        "mainwidget.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "gestures",
                                           "imagegestures")
    }
}
