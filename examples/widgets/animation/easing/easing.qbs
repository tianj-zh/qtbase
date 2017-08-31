import qbs
import qbs.FileInfo

CppApplication {
    name: "easing"
    condition: Qt.widgets.present && Qt.widgets.config.listwidget

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "animation.h",
        "easing.qrc",
        "form.ui",
        "main.cpp",
        "window.cpp",
        "window.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "animation",
                                           "easing")
    }
}
