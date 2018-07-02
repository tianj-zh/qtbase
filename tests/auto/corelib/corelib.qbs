import qbs

QtAutotestProject {
    name: "corelib_tests"
    qbsSearchPaths: qtbaseShadowDir + "/src/corelib/qbs"
    references: [
        "animation",
        "codecs",
        "global",
        "io",
        "itemmodels",
        "kernel",
        "mimetypes",
        "plugin",
        "statemachine",
        // "thread",
        // "tools",
        // "xml",
    ]
}
