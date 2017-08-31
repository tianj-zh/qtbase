import qbs
import qbs.FileInfo

CppApplication {
    name: "htmlinfo"
    condition: Qt.xml.present
    consoleApplication: true

    Depends { name: "Qt.xml"; required: false }

    files: [
        "main.cpp",
        "resources.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "xml", "htmlinfo")
    }
}
