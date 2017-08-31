import qbs
import qbs.FileInfo

CppApplication {
    name: "fademessage"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "fademessage.cpp",
        "fademessage.h",
        "fademessage.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "effects",
                                           "fademessage")
    }
}
