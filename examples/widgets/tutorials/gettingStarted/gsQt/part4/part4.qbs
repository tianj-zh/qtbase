import qbs
import qbs.FileInfo

CppApplication {
    name: "gettingStarted_part4"
    targetName: "part4"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tutorials",
                                           "gettingStarted", "gsQt", "part4")
    }
}
