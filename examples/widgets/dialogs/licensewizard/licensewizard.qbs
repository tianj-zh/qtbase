import qbs
import qbs.FileInfo

CppApplication {
    name: "licensewizard"
    condition: Qt.printsupport.present && Qt.widgets.present && Qt.widgets.config.wizard

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "licensewizard.cpp",
        "licensewizard.h",
        "licensewizard.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "dialogs",
                                           "licensewizard")
    }
}
