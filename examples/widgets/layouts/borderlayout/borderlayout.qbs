import qbs
import qbs.FileInfo

CppApplication {
    name: "borderlayout"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "borderlayout.cpp",
        "borderlayout.h",
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "layouts",
                                           "borderlayouts")
    }
}
