import qbs
import qbs.FileInfo

CppApplication {
    name: "pixelator"
    condition: Qt.widgets.present && Qt.widgets.config.tableview

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "imagemodel.cpp",
        "imagemodel.h",
        "images.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "pixeldelegate.cpp",
        "pixeldelegate.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "pixelator")
    }
}
