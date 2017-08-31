import qbs
import qbs.FileInfo

CppApplication {
    name: "extension"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "finddialog.cpp",
        "finddialog.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "dialogs",
                                           "extension")
    }
}
