import qbs
import qbs.FileInfo

CppApplication {
    name: "plugandpaint"
    condition: Qt.widgets.present && Qt.core.config.library && Qt.widgets.config.inputdialog
    destinationDirectory: FileInfo.joinPaths(project.buildDirectory, "widgets", "tools",
                                                 "plugandpaint")

    Depends { name: "pnp_basictools" }
    Depends { name: "pnp_extrafilters"; cpp.link: false }
    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "interfaces.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "paintarea.cpp",
        "paintarea.h",
        "plugindialog.cpp",
        "plugindialog.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "plugandpaint")
    }
}
