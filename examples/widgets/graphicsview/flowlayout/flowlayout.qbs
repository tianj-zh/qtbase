import qbs
import qbs.FileInfo

CppApplication {
    name: "graphicsviewflowlayout"
    targetName: "flowlayout"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "flowlayout.cpp",
        "flowlayout.h",
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "flowlayout")
    }
}
