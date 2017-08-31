import qbs
import qbs.FileInfo

CppApplication {
    name: "styles"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "norwegianwoodstyle.cpp",
        "norwegianwoodstyle.h",
        "styles.qrc",
        "widgetgallery.cpp",
        "widgetgallery.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "styles")
    }
}
