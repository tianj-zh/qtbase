import qbs
import qbs.FileInfo

CppApplication {
    name: "collidingmice"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "mice.qrc",
        "mouse.cpp",
        "mouse.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "collidingmice")
    }
}
