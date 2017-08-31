import qbs
import qbs.FileInfo

CppApplication {
    name: "rsslisting"
    condition: Qt.network.present && Qt.widgets.present && Qt.xml.present
        && Qt.widgets.config.treewidget

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }
    Depends { name: "Qt.xml"; required: false }

    files: [
        "main.cpp",
        "rsslisting.cpp",
        "rsslisting.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "xml", "rsslisting")
    }
}
