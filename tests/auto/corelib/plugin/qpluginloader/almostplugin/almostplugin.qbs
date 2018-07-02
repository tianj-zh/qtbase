import qbs

QtAutotestPlugin {
    name: "almostplugin"
    condition: base && project.theCondition
               &&!qbs.targetOS.contains("android") && !qbs.targetOS.contains("windows")
               && !qbs.targetOS.contains("darwin")
    installSuffix: "bin"

    Properties {
        condition: qbs.toolchain.contains("gcc")
        cpp.allowUnresolvedSymbols: true
    }

    files: [
        "almostplugin.cpp",
        "almostplugin.h",
    ]
}
