import qbs
import qbs.FileInfo

CppApplication {
    name: "movie"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "animation.gif",
        "main.cpp",
        "movieplayer.cpp",
        "movieplayer.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "movie")
    }
}
