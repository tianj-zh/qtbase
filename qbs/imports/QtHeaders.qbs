import qbs
import qbs.FileInfo

Product {
    name: project.headersName
    type: ["hpp_private", "hpp_public", "hpp_forwarding", "hpp_module", "hpp_qpa", "hpp_depends", "hpp"]
    condition: project.conditionFunction(qbs)
    property bool install: true
    property bool consideredBySync: true
    property bool syncable: true
    property var config: project.config
    property var privateConfig: project.privateConfig

    Depends { name: "Qt.global" }

    Depends { name: "sync"; condition: syncable }
    sync.module: project.name

    multiplexByQbsProperties: ["profiles"]
    qbs.profiles: ["qt_targetProfile"]
    aggregate: false

    Depends { name: "Exporter.qbs" }
    Exporter.qbs.fileName: project.simpleName + "_headers.qbs"

    Group {
        condition: syncable
        fileTagsFilter: ["hpp_public", "hpp_forwarding", "hpp_module", "hpp_depends"]
        qbs.install: product.install
        qbs.installDir: sync.prefix + '/' + sync.module
    }

    Group {
        condition: syncable
        fileTagsFilter: "hpp_private"
        qbs.install: product.install
        qbs.installDir: sync.prefix + '/' + sync.module + "/"
                        + project.version + "/" + sync.module
                        + "/private"
    }

    Group {
        condition: syncable
        fileTagsFilter: "hpp_qpa"
        qbs.install: product.install
        qbs.installDir: FileInfo.joinPaths(sync.prefix, sync.module, project.version, sync.module,
                                           "qpa")
    }

    Group {
        fileTagsFilter: ["Exporter.qbs.module"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths("lib/qbs/modules/Qt", project.simpleName + "_headers")
    }

    property string baseDir: sourceDirectory
    property stringList shadowBuildFiles: []

    Properties {
        condition: syncable
        files: [baseDir + "/*.h", baseDir + "/**/*.h"].concat(
                   project.isShadowBuild ? shadowBuildFiles : [])
        excludeFiles: [baseDir + "/doc/**"]
    }

    Export {
        property stringList includePaths: project.includePaths
        property stringList publicIncludePaths: project.publicIncludePaths
        prefixMapping: [{prefix: project.buildDirectory, replacement: qbs.installPrefix}]
    }
}
