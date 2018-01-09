import qbs
import qbs.FileInfo

Product {
    name: project.privateName
    condition: project.conditionFunction(qbs)
    qbsSearchPaths: FileInfo.joinPaths(project.qtbaseShadowDir, "src", FileInfo.fileName(sourceDirectory),  "qbs");

    property var config: project.privateConfig

    Depends { name: "Qt.global" }
    Depends { name: "qt_module_pri"}
    qt_module_pri.isPrivateShadowModule: true

    Export {
        Depends { name: project.moduleName }
        Depends { name: "Qt.core_private"; condition: product.name != "Qt.core_private"; }
        Depends { name: "cpp" }
        property var config: product.config
        cpp.includePaths: project.includePaths
        prefixMapping: base.concat([{
             prefix: project.buildDirectory,
             replacement: qbs.installPrefix
        }])
    }
}
