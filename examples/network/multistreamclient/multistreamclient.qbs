import qbs
import qbs.FileInfo

CppApplication {
    name: "multistreamclient"
    condition: Qt.network.present && Qt.widgets.present && Qt.network.config.sctp

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "chatconsumer.cpp",
        "chatconsumer.h",
        "client.cpp",
        "client.h",
        "consumer.h",
        "main.cpp",
        "movieconsumer.cpp",
        "movieconsumer.h",
        "timeconsumer.cpp",
        "timeconsumer.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network",
                                           "multistreamclient")
    }
}
