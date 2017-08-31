import qbs
import qbs.FileInfo

CppApplication {
    name: "part7"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "addressbook.cpp",
        "addressbook.h",
        "finddialog.cpp",
        "finddialog.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tutorials",
                                           "addressbook", "part7")
    }
}
