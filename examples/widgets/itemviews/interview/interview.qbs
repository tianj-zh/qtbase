import qbs
import qbs.FileInfo

CppApplication {
    name: "interview"
    condition: Qt.widgets.present && Qt.widgets.config.treeview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "interview.qrc",
        "main.cpp",
        "model.cpp",
        "model.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "interview")
    }
}
