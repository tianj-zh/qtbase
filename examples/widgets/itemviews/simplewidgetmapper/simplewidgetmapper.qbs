import qbs
import qbs.FileInfo

CppApplication {
    name: "simplewidgetmapper"
    condition: Qt.widgets.present && Qt.widgets.config.datawidgetmapper

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "simplewidgetmapper")
    }
}
