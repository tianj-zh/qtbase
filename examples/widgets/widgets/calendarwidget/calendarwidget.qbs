import qbs
import qbs.FileInfo

CppApplication {
    name: "calendarwidget"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "widgets",
                                           "calendarwidget")
    }
}
