import qbs
import qbs.FileInfo

CppApplication {
    name: "chart"
    condition: Qt.widgets.present && Qt.widgets.config.filedialog

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "chart.qrc",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
        "pieview.cpp",
        "pieview.h",
    ]

    Properties {
        condition: qbs.targetOS.contains("unix")
                       && !qbs.targetOS.containsAny(["darwin", "vxworks", "integrity", "haiku"])
        cpp.dynamicLibraries: base.concat("m")
    }

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "itemviews",
                                           "chart")
    }
}
