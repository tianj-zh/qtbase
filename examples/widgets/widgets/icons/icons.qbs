import qbs
import qbs.FileInfo

CppApplication {
    name: "icons"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    cpp.defines: base.concat('SRCDIR="' + sourceDirectory + '"')

    files: [
        "iconpreviewarea.cpp",
        "iconpreviewarea.h",
        "iconsizespinbox.cpp",
        "iconsizespinbox.h",
        "imagedelegate.cpp",
        "imagedelegate.h",
        "images/*",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "icons")
    }
}
