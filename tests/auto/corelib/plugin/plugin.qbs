import qbs

QtAutotestProject {
    name: "corelib_plugin_tests"
    qbsSearchPaths: ["."]
    references: [
        "qfactoryloader",
        "qlibrary",
        "qplugin",
        "qpluginloader",
        "quuid",
    ]
}
