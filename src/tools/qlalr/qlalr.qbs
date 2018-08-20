import qbs
import qbs.FileInfo
import qbs.ModUtils
import "qlalr.js" as qlalr

Project {
    QtHostTool {
        name: "qlalr"
        toolFileTag: "qt.qlalr-tool"
        qbsSearchPaths: [project.qtbaseShadowDir + "/src/corelib/qbs"]
        createQbsModule: true

        Depends { name: "Qt.core_private"; condition: !useBootstrapLib }

        cpp.defines: base.concat(["QT_NO_FOREACH"])

        files: [
            "compress.cpp",
            "compress.h",
            "cppgenerator.cpp",
            "cppgenerator.h",
            "dotgraph.cpp",
            "dotgraph.h",
            "grammar.cpp",
            "grammar_p.h",
            "lalr.cpp",
            "lalr.g",
            "lalr.h",
            "main.cpp",
            "parsetable.cpp",
            "parsetable.h",
            "recognizer.cpp",
            "recognizer.h",
        ]

        Group {
            files: ["qlalr.js"]
            qbs.install: true
            qbs.installDir: moduleInstallDir
        }

        Export {
            FileTagger {
                patterns: ["*.g"]
                fileTags: ["qt.qlalr.grammar"]
                priority: 10
            }
            Rule {
                inputs: ["qt.qlalr.grammar"]
                explicitlyDependsOnFromDependencies: ["qt.qlalr-tool"]
                outputFileTags: ["cpp", "hpp"]
                outputArtifacts: {
                    var g = qlalr.parseGrammar(input.filePath);
                    var artifacts = [];
                    function add(filePath, fileTags) {
                        if (!filePath)
                            return;
                        artifacts.push(
                            {
                                filePath: FileInfo.joinPaths(input.Qt.core.generatedHeadersDir,
                                                             filePath),
                                fileTags: fileTags
                            }
                        );
                    }
                    function addHeader(filePath) {
                        add(filePath, ["hpp"]);
                    }
                    function addSource(filePath) {
                        add(filePath, ["cpp"]);
                    }
                    if (g.merged) {
                        // ### The headerExts list should come from the cpp module and not be duplicated here.
                        var headerExts = ["*.h", "*.H", "*.hpp", "*.hxx", "*.h++"];
                        function isExtensionOfMerged(extension) {
                            return g.merged.endsWith(extension);
                        }
                        if (headerExts.some(isExtensionOfMerged))
                            addHeader(g.merged);
                        else
                            addSource(g.merged);
                    } else {
                        addHeader(g.decl);
                        addSource(g.impl);
                        var parserBase = g.parser.toLowerCase();
                        addHeader(parserBase + "_p.h");
                        addSource(parserBase + ".cpp");
                    }
                    return artifacts;
                }
                prepare: {
                    var artifact = explicitlyDependsOn["qt.qlalr-tool"][0];
                    var exe = artifact.qbs.install
                        ? ModUtils.artifactInstalledFilePath(artifact)
                        : artifact.filePath;
                    var cmd = new Command(exe, input.filePath);
                    cmd.description = "compiling " + input.fileName;
                    cmd.workingDirectory = input.Qt.core.generatedHeadersDir;
                    return cmd;
                }
            }
        }
    }
}
