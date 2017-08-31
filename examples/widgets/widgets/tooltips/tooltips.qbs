import qbs
import qbs.FileInfo

CppApplication {
    name: "tooltips"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "shapeitem.cpp",
        "shapeitem.h",
        "sortingbox.cpp",
        "sortingbox.h",
        "tooltips.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "tooltips")
    }
}
