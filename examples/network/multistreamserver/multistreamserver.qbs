import qbs
import qbs.FileInfo

CppApplication {
    name: "multistreamserver"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.sctp

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "animation.gif",
        "chatprovider.cpp",
        "chatprovider.h",
        "main.cpp",
        "movieprovider.cpp",
        "movieprovider.h",
        "provider.h",
        "server.cpp",
        "server.h",
        "timeprovider.cpp",
        "timeprovider.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network",
                                           "multistreamserver")
    }
}
