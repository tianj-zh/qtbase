import qbs
import qbs.FileInfo

CppApplication {
    name: "textedit"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.printsupport"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "textedit.cpp",
        "textedit.h",
        "textedit.qdoc",
        "textedit.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "richtext",
                                           "textedit")
    }
}
