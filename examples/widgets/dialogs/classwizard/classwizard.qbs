import qbs
import qbs.FileInfo

CppApplication {
    name: "classwizard"
    condition: Qt.widgets.present && Qt.widgets.config.wizard

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "classwizard.cpp",
        "classwizard.h",
        "classwizard.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "dialogs",
                                           "classwizard")
    }
}
