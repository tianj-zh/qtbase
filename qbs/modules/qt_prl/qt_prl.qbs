import qbs.TextFile
import "prl_helpers.js" as PrlHelpers

Module {
    additionalProductTypes: ["qt.prl"]

    property string fileName
    property stringList defines
    property stringList cFlags
    property stringList cxxFlags
    property bool explicitLibs: product.qbs.targetOS.contains("unix")
    property stringList libs // QMAKE_INTERNAL_PRL_LIBS

    Rule {
        inputs: product.type.contains("staticlibrary") ? "staticlibrary" : "dynamiclibrary"
        Artifact {
            filePath: product.qt_prl.fileName ? product.qt_prl.fileName : input.baseName + ".prl"
            fileTags: "qt.prl"
            qbs.install: true
            qbs.installDir: "lib"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.sourceCode = function() {
                var f = new TextFile(output.filePath, TextFile.WriteOnly);
                PrlHelpers.writeValue(f, "QMAKE_PRL_TARGET", input.fileName, "forbid-empty");
                PrlHelpers.writeValue(f, "QMAKE_PRL_DEFINES", product.qt_prl.defines,
                                      "ignore-empty");
                PrlHelpers.writeValue(f, "QMAKE_PRL_CFLAGS", product.qt_prl.cFlags, "ignore-empty");
                PrlHelpers.writeValue(f, "QMAKE_PRL_CXXFLAGS", product.qt_prl.cxxFlags,
                                      "ignore-empty");
                // writeValue("QMAKE_PRL_CONFIG", ??, "ignore-empty"); // TODO: How to get at the CONFIG value?
                PrlHelpers.writeValue(f, "QMAKE_PRL_VERSION", product.version, "ignore-empty"); // TODO: This entry is not always present, but what are the conditions exactly?
                if (product.type.contains("staticlibrary") || product.qt_prl.explicitLibs) {
                    var libs = (product.qt_prl.libs && product.qt_prl.libs.length > 0)
                            ? product.qt_prl.libs : PrlHelpers.collectLibraries(product);
                    PrlHelpers.writeValue(f, "QMAKE_PRL_LIBS", libs, "use-empty");
                }
                f.close();
            };
            return cmd;
        }
    }
}
