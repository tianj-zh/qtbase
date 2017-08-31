import qbs
import qbs.FileInfo

CppApplication {
    name: "styleplugin"
    condition: Qt.widgets.present
    destinationDirectory: project.buildDirectory + "/examples/widgets/tools/styleplugin"

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "stylewindow.cpp",
        "stylewindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "styleplugin")
    }
}
