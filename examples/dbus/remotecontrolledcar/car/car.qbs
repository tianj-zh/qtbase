import qbs
import qbs.FileInfo

CppApplication {
    name: "car"
    condition: Qt.dbus.present && Qt.widgets.present
    Depends { name: "Qt.dbus"; required: false }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "car.cpp",
        "car.h",
        "main.cpp",
    ]
    Group {
        name: "dbus adaptor"
        files: ["car.xml"]
        fileTags: ["qt.dbus.adaptor"]
    }
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "dbus", "remotecontrolledcar", "car")
    }
}
