import qbs
import qbs.File
import qbs.FileInfo

Project {
    references: [
        "debugplugin",
        "invalidplugin",
        "releaseplugin",
    ]

    QtAutotest {
        name: "tst_qplugin"
        condition: base && Qt.core.config.library && !Qt.global.staticBuild
        testDataInstallDir: FileInfo.joinPaths(installDir, "plugins")
        files: "tst_qplugin.cpp"

        Depends { name: "debugplugin"; required: false }
        Depends { name: "invalidplugin"; required: false }
        Depends { name: "releaseplugin"; required: false }

        Rule {
            inputsFromDependencies: Qt.global.staticBuild ? "staticlibrary" : "dynamiclibrary"
            Artifact {
                filePath: input.fileName
                fileTags: "qt.generated_testdata"
            }
            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.silent = true;
                cmd.sourceCode = function() { File.copy(input.filePath, output.filePath); }
            }
        }
    }
}
