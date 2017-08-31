import qbs
import qbs.FileInfo

CppApplication {
    name: "screenshot"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "screenshot.cpp",
        "screenshot.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "desktop",
                                           "screenshot")
    }
}
