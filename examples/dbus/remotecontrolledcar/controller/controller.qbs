import qbs
import qbs.FileInfo

CppApplication {
    name: "controller"
    condition: Qt.dbus.present && Qt.widgets.present
    Depends { name: "Qt.dbus"; required: false }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "controller.cpp",
        "controller.h",
        "controller.ui",
        "main.cpp",
    ]
    Group {
        name: "dbus interface"
        files: ["car.xml"]
        fileTags: ["qt.dbus.interface"]
    }
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "dbus", "remotecontrolledcar", "controller")
    }
}
