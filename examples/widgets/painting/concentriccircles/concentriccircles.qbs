import qbs
import qbs.FileInfo

CppApplication {
    name: "concentriccircles"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "circlewidget.cpp",
        "circlewidget.h",
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "concentriccircles")
    }
}
