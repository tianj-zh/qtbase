import qbs

QtAutotestPlugin {
    name: "plugin2"
    condition: base && !Qt.core.config.staticBuild
    installSuffix: "bin"

    Properties {
        condition: !Qt.core.config.library
        cpp.defines: base.concat("QT_STATICPLUGIN")
    }

    files: [
        "plugin2.cpp",
        "plugin2.h",
    ]
}
