import qbs

Product {
    name: "examples (deployment)"
    multiplexByQbsProperties: ["profiles"]
    qbs.profiles: ["qt_targetProfile"]
    Group {
        files: [
            "**"
        ]
        excludeFiles: [
            "examples-all.qbs",
            "examples-deployment.qbs",
            "examples-products.qbs",
            "imports/*",
            "**/doc/**/*",
            "aggregate/examples.pro",

            // TODO:
            // The following don't seem to get installed when building with qmake,
            // though I don't see in all cases how they are excluded and whether
            // that is on purpose.
            "embedded/**",
            "qmake/**",
        ]
        qbs.install: true
        qbs.installDir: "examples"
        qbs.installSourceBase: sourceDirectory
    }
}
