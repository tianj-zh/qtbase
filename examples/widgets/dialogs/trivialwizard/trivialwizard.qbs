import qbs
import qbs.FileInfo

CppApplication {
    name: "trivialwizard"
    condition: Qt.widgets.present && Qt.widgets.config.wizard

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "trivialwizard.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "dialogs",
                                           "trivialwizard")
    }
}
