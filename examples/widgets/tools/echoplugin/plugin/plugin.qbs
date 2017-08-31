import qbs
import qbs.FileInfo

DynamicLibrary {
    name: "echoplugin"
    condition: Qt.widgets.present && Qt.core.config.library
    destinationDirectory: project.buildDirectory + "/examples/widgets/tools/echoplugin/plugins"

    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }

    cpp.includePaths: base.concat("../echowindow")

    files: [
        "echoplugin.cpp",
        "echoplugin.h",
        "echoplugin.json",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "dynamiclibrary")
    }
}

// CONFIG         += plugin
