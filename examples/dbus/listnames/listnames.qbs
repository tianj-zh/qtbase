import qbs
import qbs.FileInfo

CppApplication {
    name: "listnames"
    condition: Qt.dbus.present
    consoleApplication: qbs.targetOS.contains("windows")

    Depends { name: "Qt.dbus"; required: false }

    files: [
        "listnames.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "dbus", "listnames")
    }
}
