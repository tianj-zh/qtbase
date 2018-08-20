import qbs
import qbs.FileInfo
import qbs.Utilities

Module {
    Depends { name: "cpp" }
    cpp.commonCompilerFlags: {
        var flags = [];
        if (cpp.compilerVersionMajor >= 19) {
            flags.push("/Zc:strictStrings");
        }
        return flags;
    }
    cpp.cxxFlags: {
        var flags = [];
        if (cpp.compilerVersionMajor >= 18) {
            flags.push("/Zc:rvalueCast", "/Zc:inline");
        }
        if (cpp.compilerVersionMajor >= 19) {
            flags.push("/Zc:throwingNew");
            if (cpp.compilerVersionMinor >= 1) {
                flags.push("/Zc:referenceBinding");
            }
        }
        return flags;
    }

    cpp.defines: {
        var defines = [];
        // MSVC 2017 15.8+ fixed std::aligned_storage but compilation fails without
        // this flag since the fix breaks binary compatibility.
        if (Utilities.versionCompare(cpp.compilerVersion, "19.14") > 0)
            defines.push("_ENABLE_EXTENDED_ALIGNED_STORAGE");
        return defines;
    }
    property string windowsKitDir: cpp.buildEnv["WindowsSdkDir"]
    property string windowsKitVersion: {
        var s = cpp.buildEnv["WindowsSDKVersion"];
        if (s)
            return s.replace(/\\$/, "");
        return undefined;
    }
    property string windowsKitIncludeDir: FileInfo.joinPaths(windowsKitDir,
                                                             "Include", windowsKitVersion)
    Properties {
        condition: product.targetsUWP
        cpp.windowsApiFamily: "pc"
        cpp.includePaths: [
            "shared",
            "ucrt",
            "um",
            "winrt",
        ].map(function(s) { return FileInfo.joinPaths(windowsKitIncludeDir, s); })
    }
    cpp.dynamicLibraries: {
        var libs = [];
        if (product.targetsUWP) {
            libs.push("runtimeobject");
        }
        return libs;
    }
}
