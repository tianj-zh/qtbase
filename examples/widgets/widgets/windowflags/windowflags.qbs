import qbs
import qbs.FileInfo

CppApplication {
    name: "windowflags"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "controllerwindow.cpp",
        "controllerwindow.h",
        "main.cpp",
        "previewwindow.cpp",
        "previewwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "windowflags")
    }
}
