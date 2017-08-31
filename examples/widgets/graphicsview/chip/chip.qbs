import qbs
import qbs.FileInfo

CppApplication {
    name: "chip"
    condition: Qt.widgets.present

    Depends { name: "Qt.opengl"; required: false }
    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "chip.cpp",
        "chip.h",
        "images.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "view.cpp",
        "view.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "chip")
    }
}
