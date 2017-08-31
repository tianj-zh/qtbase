import qbs
import qbs.FileInfo

CppApplication {
    name: "qmacnativewidget"
    condition: Qt.widgets.present && qbs.targetOS.contains("macos")

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.mm",
    ]

    cpp.frameworks: base.concat("AppKit")

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "mac",
                                           "qmacnativewidget")
    }
}
