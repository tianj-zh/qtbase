import qbs
import qbs.FileInfo

CppApplication {
    name: "stardelegate"
    condition: Qt.widgets.present && Qt.widgets.config.tablewidget

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "stardelegate.cpp",
        "stardelegate.h",
        "stareditor.cpp",
        "stareditor.h",
        "starrating.cpp",
        "starrating.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "stardelegate")
    }
}
