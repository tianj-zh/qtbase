import qbs
import qbs.FileInfo

CppApplication {
    name: "calculator"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "button.cpp",
        "button.h",
        "calculator.cpp",
        "calculator.h",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "calculator")
    }
}
