import qbs
import qbs.FileInfo

CppApplication {
    name: "contiguouscache"
    condition: Qt.widgets.present && Qt.widgets.config.listview
    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "main.cpp",
        "randomlistmodel.cpp",
        "randomlistmodel.h",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "tools", "contiguouscache")
    }
}
