import qbs
import qbs.FileInfo

CppApplication {
    name: "googlesuggest"
    condition: Qt.network.present && Qt.widgets.present && Qt.widgets.config.itemviews

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "googlesuggest.cpp",
        "googlesuggest.h",
        "main.cpp",
        "searchbox.cpp",
        "searchbox.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "googlesuggest")
    }
}
