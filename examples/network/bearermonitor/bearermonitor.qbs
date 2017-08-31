import qbs
import qbs.FileInfo

CppApplication {
    name: "bearermonitor"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.bearermanagement
        && Qt.widgets.config.treeview
    consoleApplication: true

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "bearermonitor.cpp",
        "bearermonitor.h",
        "bearermonitor_240_320.ui",
        "bearermonitor_640_480.ui",
        "main.cpp",
        "sessionwidget.cpp",
        "sessionwidget.h",
        "sessionwidget.ui",
    ]

    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.dynamicLibraries: base.concat("ws2_32")
    }

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "bearermonitor")
    }
}
