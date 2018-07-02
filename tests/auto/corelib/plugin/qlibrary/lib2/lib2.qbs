import qbs
import qbs.File

QtAutotestAuxBinary {
    name: "mylib2"
    condition: base && Qt.core.config.library
    targetName: qbs.targetOS.contains("windows") ? "mylib2" : "mylib"
    binaryType: ["dynamiclibrary", "dllcopy", "dynamiclibrary_symlink"]
    installSuffix: ""
    version: "2"
    property bool isWindows: qbs.targetOS.contains("windows")

    Depends { name: "Qt.core" }

    Properties {
        condition: !isWindows
        cpp.internalVersion: "2"
    }
    Properties {
        condition: qbs.toolchain.contains("msvc")
        cpp.defines: base.concat("WIN32_MSVC")
    }

    // Force a copy of the library to have an extension that is non-standard.
    // We want to test if we can load a shared library with *any* filename...
    Rule {
        inputs: "dynamiclibrary"
        Artifact {
            filePath: product.isWindows ? "mylib.dl2" : "libmylib.so2"
            fileTags: "dllcopy"
        }
        Artifact {
            filePath: "system.qt.test.mylib." + (product.isWindows ? "dll" : "so")
            fileTags: "dllcopy"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "Creating test plugin copies";
            cmd.sourceCode = function() {
                for (var i = 0; i < outputs.dllcopy.length; ++i)
                    File.copy(input.filePath, outputs.dllcopy[i].filePath);
            };
            return [cmd];
        }
    }

    files: "mylib.c"
}
