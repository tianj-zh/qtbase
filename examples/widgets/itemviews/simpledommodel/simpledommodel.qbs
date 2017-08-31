import qbs
import qbs.FileInfo

CppApplication {
    name: "simpledommodel"
    condition: Qt.widgets.present && Qt.xml.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }
    Depends { name: "Qt.xml"; required: false }

    files: [
        "domitem.cpp",
        "domitem.h",
        "dommodel.cpp",
        "dommodel.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "simpledommodel")
    }
}
