import qbs
import qbs.FileInfo

CppApplication {
    name: "tutorial2"
    condition: Qt.testlib.present && Qt.widgets.present

    Depends { name: "Qt.testlib"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "testqstring.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "qtestlib", "tutorial2")
    }
}
