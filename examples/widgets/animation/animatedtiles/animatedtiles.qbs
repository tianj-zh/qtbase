import qbs
import qbs.FileInfo

CppApplication {
    name: "animatedtiles"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "animatedtiles.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "animation",
                                           "animated-tiles")
    }
}
