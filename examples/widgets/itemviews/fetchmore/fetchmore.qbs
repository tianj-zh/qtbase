import qbs
import qbs.FileInfo

CppApplication {
    name: "fetchmore"
    condition: Qt.widgets.present && Qt.widgets.config.listview

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "filelistmodel.cpp",
        "filelistmodel.h",
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "fetchmore")
    }
}
