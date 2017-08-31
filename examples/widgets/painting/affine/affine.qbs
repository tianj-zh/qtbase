import qbs
import qbs.FileInfo

import "../shared/shared.qbs" as SharedSources

CppApplication {
    name: "affine"
    condition: Qt.widgets.present

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.opengl"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    property stringList openglDefines: []
    Properties {
        condition: Qt.opengl.present || Qt.gui.config.opengles2
        openglDefines: ["QT_OPENGL_SUPPORT"]
    }
    cpp.defines: base.concat(openglDefines)
    cpp.includePaths: ["../shared"]

    SharedSources { }
    files: [
        "affine.qrc",
        "main.cpp",
        "xform.cpp",
        "xform.h",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "affine")
    }
}
