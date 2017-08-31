import qbs
import qbs.FileInfo

CppApplication {
    name: "basicgraphicslayouts"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "basicgraphicslayouts.qrc",
        "layoutitem.cpp",
        "layoutitem.h",
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "basicgraphicslayout")
    }
}
