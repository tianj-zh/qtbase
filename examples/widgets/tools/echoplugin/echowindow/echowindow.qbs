import qbs
import qbs.FileInfo

CppApplication {
    name: "echopluginwindow"
    targetName: "echoplugin"
    condition: Qt.widgets.present && Qt.core.config.library
    destinationDirectory: project.buildDirectory + "/examples/widgets/tools/echoplugin"

    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "echointerface.h",
        "echowindow.cpp",
        "echowindow.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "echoplugin")
    }
}
