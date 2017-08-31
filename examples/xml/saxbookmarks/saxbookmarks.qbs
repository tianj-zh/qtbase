import qbs
import qbs.FileInfo

CppApplication {
    name: "saxbookmarks"
    condition: Qt.widgets.present && Qt.xml.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }
    Depends { name: "Qt.xml"; required: false }

    files: [
        "jennifer.xbel",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "xbelgenerator.cpp",
        "xbelgenerator.h",
        "xbelhandler.cpp",
        "xbelhandler.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "xml", "saxbookmarks")
    }
}
