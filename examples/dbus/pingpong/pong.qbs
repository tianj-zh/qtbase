import qbs
import qbs.FileInfo

CppApplication {
    name: "pong"
    condition: Qt.dbus.present

    Depends { name: "Qt.dbus"; required: false }

    files: [
        "ping-common.h",
        "pong.cpp",
        "pong.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "dbus", "pingpong")
    }
}
