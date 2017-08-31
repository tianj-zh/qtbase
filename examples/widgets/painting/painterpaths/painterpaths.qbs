import qbs
import qbs.FileInfo

CppApplication {
    name: "painterpaths"
    condition: Qt.widgets.present && Qt.widgets.config.combobox

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "main.cpp",
        "renderarea.cpp",
        "renderarea.h",
        "window.cpp",
        "window.h",
    ]

    Properties {
        condition: qbs.targetOS.contains("unix")
                       && !qbs.targetOS.containsAny(["darwin", "vxworks", "integrity", "haiku"])
        cpp.dynamicLibraries: base.concat("m")
    }

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "painterpaths")
    }
}
