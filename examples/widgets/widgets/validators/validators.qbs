import qbs
import qbs.FileInfo

CppApplication {
    name: "validators"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    cpp.includePaths: base.concat(".")

    files: [
        "ledwidget.cpp",
        "ledwidget.h",
        "localeselector.cpp",
        "localeselector.h",
        "main.cpp",
        "validators.qrc",
        "validators.ui",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "validators")
    }
}
