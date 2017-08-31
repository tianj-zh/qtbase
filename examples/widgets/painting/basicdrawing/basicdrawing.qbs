import qbs
import qbs.FileInfo

CppApplication {
    name: "basicdrawing"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "basicdrawing.qrc",
        "main.cpp",
        "renderarea.cpp",
        "renderarea.h",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "basicdrawing")
    }
}
