import qbs
import qbs.FileInfo

QtProduct {
    type: ["application"]

    Properties {
        condition: qbs.targetOS.contains("darwin")
        bundle.isBundle: false
    }
    qbs.buildVariants: project.debugAndRelease ? ["release"] : []
    aggregate: false

    cpp.defines: []
}
