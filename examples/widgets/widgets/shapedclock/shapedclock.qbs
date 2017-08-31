import qbs
import qbs.FileInfo

CppApplication {
    name: "shapedclock"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "shapedclock.cpp",
        "shapedclock.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "shapedclock")
    }
}
