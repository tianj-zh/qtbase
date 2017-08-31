import qbs
import qbs.FileInfo

CppApplication {
    name: "tutorial4"
    condition: Qt.testlib.present && Qt.widgets.present

    Depends { name: "Qt.testlib"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "testgui.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "qtestlib", "tutorial4")
    }
}
