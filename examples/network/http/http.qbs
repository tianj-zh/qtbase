import qbs
import qbs.FileInfo

CppApplication {
    name: "http"
    condition: Qt.network.present && Qt.widgets.present

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "authenticationdialog.ui",
        "httpwindow.cpp",
        "httpwindow.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "http")
    }
}
