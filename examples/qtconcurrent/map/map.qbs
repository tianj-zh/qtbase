import qbs
import qbs.FileInfo

CppApplication {
    name: "mapdemo"
    condition: Qt.concurrent.present && Qt.gui.present
    consoleApplication: true

    Depends { name: "Qt.concurrent"; required: false }
    Depends { name: "Qt.gui"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "qtconcurrent",
                                           "map")
    }
}
