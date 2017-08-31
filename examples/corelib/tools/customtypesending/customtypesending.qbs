import qbs
import qbs.FileInfo

CppApplication {
    name: "customtypesending"
    condition: Qt.widgets.present
    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }
    files: [
        "main.cpp",
        "message.cpp",
        "message.h",
        "window.cpp",
        "window.h",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "tools", "customcompleter")
    }
}
