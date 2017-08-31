import qbs
import qbs.FileInfo

CppApplication {
    name: "dombookmarks"
    condition: Qt.widgets.present && Qt.xml.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }
    Depends { name: "Qt.xml"; required: false }

    files: [
        "jennifer.xbel",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "xbeltree.cpp",
        "xbeltree.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "xml", "dombookmarks")
    }
}
