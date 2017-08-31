import qbs
import qbs.FileInfo

CppApplication {
    name: "dragdroprobot"
    condition: Qt.widgets.present && Qt.gui.config.cursor && Qt.gui.config.draganddrop

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "coloritem.cpp",
        "coloritem.h",
        "main.cpp",
        "robot.cpp",
        "robot.h",
        "robot.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "dragdroprobot")
    }
}
