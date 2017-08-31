import qbs
import qbs.FileInfo

CppApplication {
    name: "regularexpression"
    condition: Qt.widgets.present && Qt.widgets.config.treewidget

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "regularexpressiondialog.cpp",
        "regularexpressiondialog.h",
        "regularexpression.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "regularexpression")
    }
}
