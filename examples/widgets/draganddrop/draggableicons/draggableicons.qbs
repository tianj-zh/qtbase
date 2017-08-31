import qbs
import qbs.FileInfo

CppApplication {
    name: "draggableicons"
    condition: Qt.widgets.present && Qt.gui.config.draganddrop

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "draggableicons.qrc",
        "dragwidget.cpp",
        "dragwidget.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "draganddrop",
                                           "draggableicons")
    }
}
