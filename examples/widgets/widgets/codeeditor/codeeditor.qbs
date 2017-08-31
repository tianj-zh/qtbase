import qbs
import qbs.FileInfo

CppApplication {
    name: "codeeditor"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "codeeditor.cpp",
        "codeeditor.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "codeeditor")
    }
}
