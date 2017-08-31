import qbs
import qbs.FileInfo

CppApplication {
    name: "weatheranchorlayout"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "weatheranchorlayout.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "graphicsview",
                                           "anchorlayout")
    }
}
