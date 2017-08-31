import qbs
import qbs.FileInfo

DynamicLibrary {
    name: "simplestyleplugin"
    condition: Qt.widgets.present
    destinationDirectory: project.buildDirectory + "/examples/widgets/tools/styleplugin/styles"

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "simplestyle.cpp",
        "simplestyle.h",
        "simplestyle.json",
        "simplestyleplugin.cpp",
        "simplestyleplugin.h",
    ]

    Group {
        fileTagsFilter: ["dynamiclibrary"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "styleplugin", "styles")
    }
}
