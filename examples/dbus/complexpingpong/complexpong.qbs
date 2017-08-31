import qbs
import qbs.FileInfo

CppApplication {
    name: "complexpong"
    condition: Qt.dbus.present

    Depends { name: "Qt.dbus"; required: false }

    files: [
        "complexpong.cpp",
        "complexpong.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "dbus", "complexpingpong")
    }
}
