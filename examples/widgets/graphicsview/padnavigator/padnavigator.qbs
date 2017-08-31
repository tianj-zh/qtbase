import qbs
import qbs.FileInfo

CppApplication {
    name: "padnavigator"
    condition: Qt.widgets.present && Qt.widgets.config.treewidget
    consoleApplication: true

    Depends { name: "Qt.opengl"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "flippablepad.cpp",
        "flippablepad.h",
        "form.ui",
        "main.cpp",
        "padnavigator.cpp",
        "padnavigator.h",
        "padnavigator.qrc",
        "roundrectitem.cpp",
        "roundrectitem.h",
        "splashitem.cpp",
        "splashitem.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "padnavigator")
    }
}
