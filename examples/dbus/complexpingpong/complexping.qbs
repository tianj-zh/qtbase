import qbs
import qbs.FileInfo

CppApplication {
    name: "complexping"
    condition: Qt.dbus.present

    Depends { name: "Qt.dbus"; required: false }

    files: [
        "complexping.cpp",
        "complexping.h",
        "ping-common.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "dbus", "complexpingpong")
    }
}
