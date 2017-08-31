import qbs
import qbs.FileInfo

CppApplication {
    name: "imagecomposition"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "imagecomposer.cpp",
        "imagecomposer.h",
        "imagecomposition.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "imagecomposition")
    }
}
