import qbs

StaticLibrary {
    name: "pnp_basictools"
    condition: Qt.widgets.present && Qt.core.config.library

    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }

    cpp.includePaths: base.concat("../../app")
    cpp.defines: base.concat(["QT_PLUGIN", "QT_STATICPLUGIN"])

    files: [
        "basictools.json",
        "basictoolsplugin.cpp",
        "basictoolsplugin.h",
    ]
}
