import qbs
import qbs.FileInfo

CppApplication {
    name: "elasticnodes"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "edge.cpp",
        "edge.h",
        "graphwidget.cpp",
        "graphwidget.h",
        "main.cpp",
        "node.cpp",
        "node.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "elasticnodes")
    }
}
