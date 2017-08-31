import qbs
import qbs.FileInfo

CppApplication {
    name: "xmlstreamlint"
    condition: Qt.xml.present
    consoleApplication: true

    Depends { name: "Qt.xml"; required: false }

    files: [
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "xml", "xmlstreamlint")
    }
}
