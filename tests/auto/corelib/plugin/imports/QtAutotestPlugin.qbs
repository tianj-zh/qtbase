import qbs
import QtGlobalConfig

QtAutotestAuxBinary {
    type: binaryType
    binaryType: Qt.global.config.staticBuild ? "staticlibrary" : "dynamiclibrary"

    Depends { name: "Qt.core" }

    cpp.defines: base.concat("QT_PLUGIN").concat(Qt.global.staticBuild ? ["QT_STATICPLUGIN"] : [])

    Export {
        Parameters { cpp.link: QtGlobalConfig.staticBuild }
    }
}
