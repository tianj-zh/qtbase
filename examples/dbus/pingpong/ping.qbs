import qbs
import qbs.FileInfo

CppApplication {
    name: "ping"
    condition: Qt.dbus.present

    Depends { name: "Qt.dbus"; required: false }

    files: [
        "ping-common.h",
        "ping.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "dbus", "pingpong")
    }
}
