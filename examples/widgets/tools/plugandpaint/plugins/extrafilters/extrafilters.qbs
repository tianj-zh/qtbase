import qbs
import qbs.FileInfo

DynamicLibrary {
    name: "pnp_extrafilters"
    condition: Qt.widgets.present && Qt.core.config.library
    type: ["dynamiclibrary"]
    destinationDirectory: project.buildDirectory + "/examples/widgets/tools/plugandpaint/plugins"

    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }

    cpp.includePaths: base.concat("../../app")

    files: [
        "extrafilters.json",
        "extrafiltersplugin.cpp",
        "extrafiltersplugin.h",
    ]

    Group {
        fileTagsFilter: ["dynamiclibrary"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "plugandpaint", "plugins")
    }
}

// CONFIG       += plugin
