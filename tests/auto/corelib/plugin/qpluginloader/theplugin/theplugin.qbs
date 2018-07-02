import qbs

QtAutotestPlugin {
    name: "theplugin"
    condition: base && project.theCondition
    installSuffix: "bin"

    // Use a predictable name for the plugin, no debug extension. Just like most apps do.
    cpp.variantSuffix: ""

    files: [
        "theplugin.cpp",
        "theplugin.h",
    ]
}
