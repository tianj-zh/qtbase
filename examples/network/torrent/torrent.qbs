import qbs
import qbs.FileInfo

CppApplication {
    name: "torrent"
    condition: Qt.network.present && Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.network"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "addtorrentdialog.cpp",
        "addtorrentdialog.h",
        "bencodeparser.cpp",
        "bencodeparser.h",
        "connectionmanager.cpp",
        "connectionmanager.h",
        "filemanager.cpp",
        "filemanager.h",
        "forms/addtorrentform.ui",
        "icons.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "metainfo.cpp",
        "metainfo.h",
        "peerwireclient.cpp",
        "peerwireclient.h",
        "ratecontroller.cpp",
        "ratecontroller.h",
        "torrentclient.cpp",
        "torrentclient.h",
        "torrentserver.cpp",
        "torrentserver.h",
        "trackerclient.cpp",
        "trackerclient.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "network", "torrent")
    }
}
