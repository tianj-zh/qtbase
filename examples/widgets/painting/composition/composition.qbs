import qbs
import qbs.FileInfo

import "../shared/shared.qbs" as SharedSources

CppApplication {
    name: "composition"
    condition: Qt.widgets.present

    Depends { name: "Qt.gui"; required: false }
    Depends { name: "Qt.opengl"; required: false }
    Depends { name: "Qt.widgets"; required: false }

    property stringList useOpenglDefines: []
    Properties {
        condition: Qt.opengl.present && !Qt.gui.config.dynamicgl
        useOpenglDefines: ["USE_OPENGL"]
    }
    property stringList openglSupportDefines: []
    Properties {
        condition: Qt.opengl.present || Qt.gui.config.opengles2
        openglSupportDefines: ["QT_OPENGL_SUPPORT"]
    }
    cpp.defines: base.concat(openglSupportDefines).concat(useOpenglDefines)
    cpp.includePaths: ["../shared"]

    SharedSources { }
    files: [
        "composition.cpp",
        "composition.h",
        "composition.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "painting",
                                           "composition")
    }
}
