import qbs
import qbs.FileInfo

CppApplication {
    name: "imageviewer"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "imageviewer.cpp",
        "imageviewer.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "imageviewer")
    }
}
