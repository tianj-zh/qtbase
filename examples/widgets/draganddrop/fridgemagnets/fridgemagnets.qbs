import qbs
import qbs.FileInfo

CppApplication {
    name: "fridgemagnets"
    condition: Qt.widgets.present && Qt.gui.config.draganddrop

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "draglabel.cpp",
        "draglabel.h",
        "dragwidget.cpp",
        "dragwidget.h",
        "fridgemagnets.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "draganddrop",
                                           "fridgemagnets")
    }
}
