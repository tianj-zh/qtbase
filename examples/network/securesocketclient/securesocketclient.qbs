import qbs
import qbs.FileInfo

CppApplication {
    name: "securesocketclient"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.openssl
        && Qt.widgets.config.combobox && Qt.widgets.config.listwidget

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "certificateinfo.cpp",
        "certificateinfo.h",
        "certificateinfo.ui",
        "main.cpp",
        "securesocketclient.qrc",
        "sslclient.cpp",
        "sslclient.h",
        "sslclient.ui",
        "sslerrors.ui",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network",
                                           "securesocketclient")
    }
}
