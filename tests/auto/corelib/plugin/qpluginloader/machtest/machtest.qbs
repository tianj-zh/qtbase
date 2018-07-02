import qbs
import QtGlobalPrivateConfig

Project {
    qbsSearchPaths: ["."]
    property var conditionFunc: (function(qbs) {
        return project.theCondition && QtGlobalPrivateConfig.private_tests
                && qbs.targetOS.contains("darwin");
    })

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest.i386"
        condition: base && project.conditionFunc(qbs)
        targetName: "good.i386"
        binaryType: "dynamiclibrary"
        multiplexByQbsProperties: []
        installSuffix: "lib"
        qbs.architecture: "x86"
        files: "../fakeplugin.cpp"
    }

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest.x86_64"
        condition: base && project.conditionFunc(qbs)
        targetName: "good." + qbs.architecture
        binaryType: "dynamiclibrary"
        multiplexByQbsProperties: []
        installSuffix: "lib"
        qbs.architecture: "x86_64"
        files: "../fakeplugin.cpp"
    }

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest.ppc64"
        condition: base && project.conditionFunc(qbs)
        targetName: "good." + qbs.architecture
        binaryType: "dynamiclibrary"
        installSuffix: "lib"
        multiplexByQbsProperties: []
        qbs.architecture: "ppc64"

        Depends { name: "tst_qpluginloadermachtest.x86_64" }

        Group {
            name: "PPC converter"
            files: "ppcconverter.pl"
            fileTags: "converter"
        }

        // Current Mac OS X toolchains have no compiler for PPC anymore
        // So we fake it by converting an x86-64 binary to (little-endian!) PPC64
        Rule {
            inputsFromDependencies: "dynamiclibrary"
            explicitlyDependsOn: "ppc-converter"

            Artifact {
                filePath: "good.ppc64"
                fileTags: "dynamiclibrary"
            }

            prepare: {
                var cmd = new Command(explicitlyDependsOn.converter[0].filePath,
                                      [input.filePath, output.filePath]);
                cmd.workingDirectory = product.sourceDirectory;
                return cmd;
            }
        }
    }

    // Generate a fat binary with three architectures
    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest_fat.all"
        condition: base && project.conditionFunc(qbs)
        targetName: "good.fat.all"
        binaryType: "dynamiclibrary_fat"
        installSuffix: "lib"

        Depends { name: "tst_qpluginloadermachtest.i386" }
        Depends { name: "tst_qpluginloadermachtest.x86_64" }
        Depends { name: "tst_qpluginloadermachtest.ppc64" }
        Depends { name: "machfat" }
    }

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest_fat.no-i386"
        condition: base && project.conditionFunc(qbs)
        targetName: "good.fat.no-i386"
        binaryType: "dynamiclibrary_fat"
        installSuffix: "lib"

        Depends { name: "tst_qpluginloadermachtest.x86_64" }
        Depends { name: "tst_qpluginloadermachtest.ppc64" }
        Depends { name: "machfat" }
    }

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest_fat.no-x86_64"
        condition: base && project.conditionFunc(qbs)
        targetName: "good.fat.no-x86_64"
        binartyType: "dynamiclibrary_fat"
        installSuffix: "lib"

        Depends { name: "tst_qpluginloadermachtest.i386" }
        Depends { name: "tst_qpluginloadermachtest.ppc64" }
        Depends { name: "machfat" }
    }

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest_fat.stub-i386"
        condition: base && project.conditionFunc(qbs)
        targetName: "good.fat.stub-i386.dylib"
        binaryTtype: "dynamiclibrary_fat"
        installSuffix: "lib"

        Depends { name: "tst_qpluginloadermachtest.ppc64" }
        Depends { name: "machfat" }

        machfat.additionalLipoArgs: ["-arch_blank", "i386"]
    }

    QtAutotestAuxBinary {
        name: "tst_qpluginloadermachtest_fat.stub-x86_64"
        condition: base && project.conditionFunc(qbs)
        targetName: "good.fat.stub-x86_64.dylib"
        binaryType: "dynamiclibrary_fat"
        installSuffix: "lib"

        Depends { name: "tst_qpluginloadermachtest.ppc64" }
        Depends { name: "machfat" }

        machfat.additionalLipoArgs: ["-arch_blank", "x86_64"]
    }

    QtProduct {
        condition: base && project.conditionFunc(qbs)
        type: "bad-file"

        Group {
            name: "badness generator"
            files: "generate-bad.pl"
            fileTags: "generator"
        }

        Rule {
            multiplex: true
            explicitlyDependsOn: "generator"

            Artifact { // TODO: Use the real file paths
                filePath: ".dummy"
                fileTags: "bad-file"
            }

            prepare: {
                var cmd = new Command(explicitlyDependsOn.generator[0].filePath);
                cmd.workingDirectory = product.buildDirectory;
                return cmd;
            }
        }
    }
}
