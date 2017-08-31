import qbs
import qbs.FileInfo

CppApplication {
    name: "widgets_analogclock"
    targetName: "analogclock"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "analogclock.cpp",
        "analogclock.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "analogclock")
    }
}
