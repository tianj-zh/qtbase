import qbs
import qbs.FileInfo

QtAutotestPlugin {
    name: "plugin1"
    condition: base && !Qt.core.config.staticBuild
    installSuffix: "bin"

    Properties {
        condition: !Qt.core.config.library
        cpp.defines: base.concat("QT_STATICPLUGIN")
    }

    files: [
        "plugin1.cpp",
        "plugin1.h",
    ]
}
