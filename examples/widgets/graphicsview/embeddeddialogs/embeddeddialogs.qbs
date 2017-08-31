import qbs
import qbs.FileInfo

CppApplication {
    name: "embeddeddialogs"
    condition: Qt.widgets.present && Qt.gui.fontcombobox

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "customproxy.cpp",
        "customproxy.h",
        "embeddeddialog.cpp",
        "embeddeddialog.h",
        "embeddeddialog.ui",
        "embeddeddialogs.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "embeddeddialogs")
    }
}
