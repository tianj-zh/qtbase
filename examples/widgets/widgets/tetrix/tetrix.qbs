import qbs
import qbs.FileInfo

CppApplication {
    name: "tetrix"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "tetrixboard.cpp",
        "tetrixboard.h",
        "tetrixpiece.cpp",
        "tetrixpiece.h",
        "tetrixwindow.cpp",
        "tetrixwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "tetrix")
    }
}
