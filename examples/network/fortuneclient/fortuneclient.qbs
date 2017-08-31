import qbs
import qbs.FileInfo

CppApplication {
    name: "fortuneclient"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.bearermanagement
        && Qt.widgets.config.combobox

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "client.cpp",
        "client.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "fortuneclient")
    }
}
