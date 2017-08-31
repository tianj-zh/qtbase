import qbs
import qbs.FileInfo

CppApplication {
    name: "mousebuttons"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "buttontester.cpp",
        "buttontester.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "mousebuttons")
    }
}
