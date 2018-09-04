var FileInfo = require("qbs.FileInfo");
var QtUtils = require("QtUtils");

function writeValue(file, key, value, emptyValueHandling) {
    if (!value || value.length === 0) {
        if (emptyValueHandling === "ignore-empty")
            return;
        if (emptyValueHandling === "forbid-empty")
            throw "Value for prl key '" + key + "' must not be empty.";
        if (emptyValueHandling !== "use-empty") {
            throw "Unexpected empty value handling mode '"
                    + emptyValueHandling + "'.";
        }
    }
    var quotedValue = QtUtils.qmakeQuote(value);
    if (Array.isArray(quotedValue))
        quotedValue = quotedValue.join(' ');
    file.writeLine(key + " = " + quotedValue);
}

function collectLibraries(topLevelProduct)
{
    var publicLibs = [];
    var privateLibs = [];
    var considerPrivate = topLevelProduct.type.contains("staticlibrary");
    var isTopLevelProduct = true;

    function libPathToLinkerArg(lib)
    {
        if (FileInfo.isAbsolutePath(lib)) {
            lib = FileInfo.baseName(lib);
            if (topLevelProduct.qbs.targetOS.contains("unix") && lib.startsWith("lib"))
                lib = lib.slice(3);
        }
        return "-l" + lib;
    }

    function collectLibsFromProperties(libs, cppModule) {
        if (!cppModule)
            return;
        var libPaths = cppModule.libraryPaths;
        if (libPaths)
            libs.push.apply(libs, libPaths.map(function(p) { return "-L" + p; }));
        function libNamesToLibEntries(libNames) {
            return libNames.map(function(libName) { return libPathToLinkerArg(libName); });
        };
        var dlls = cppModule.dynamicLibraries;
        if (dlls)
            libs.push.apply(libs, libNamesToLibEntries(dlls));
        var staticLibs = cppModule.staticLibraries;
        if (staticLibs)
            libs.push.apply(libs, libNamesToLibEntries(staticLibs));

        // TODO: Probably not all linker flags... Maybe just look for pthread stuff?
        var lFlags = cppModule.linkerFlags;
        if (lFlags)
            libs.push.apply(libs, lFlags);
        lFlags = cppModule.driverFlags;
        if (lFlags)
            libs.push.apply(libs, lFlags);
        lFlags = cppModule.driverLinkerFlags;
        if (lFlags)
            libs.push.apply(libs, lFlags);
    };

    function collectLibs(productOrModule, privateContext)
    {
        var libArtifacts;
        var isProduct = !productOrModule.present;
        var theLibs = privateContext ? privateLibs : publicLibs;
        if (!isTopLevelProduct) {
            var considerDynamicLibs = !isProduct || productOrModule.type
                    && productOrModule.type.contains("dynamiclibrary");
            if (considerDynamicLibs) {
                libArtifacts = productOrModule.artifacts.dynamiclibrary;
            } else {
                var considerStaticLibs = !isProduct || (productOrModule.type
                        && productOrModule.type.contains("staticlibrary"));
                if (considerStaticLibs)
                    libArtifacts = productOrModule.artifacts.staticlibrary;
            }
        }
        for (var i = 0; i < (libArtifacts || []).length; ++i)
            theLibs.push(libPathToLinkerArg(libArtifacts[i].filePath));
        if (!privateContext)
            collectLibsFromProperties(theLibs, productOrModule.exports.cpp);
        if (isProduct && considerPrivate)
            collectLibsFromProperties(privateLibs, productOrModule.cpp);
    }

    function collectLibrariesRecursive(productOrModule, privateContext)
    {
        collectLibs(productOrModule, privateContext);
        isTopLevelProduct = false;
        var exportedDeps = productOrModule.exports ? productOrModule.exports.dependencies : [];
        var exportedDepNames = [];
        var privateDeps = [];
        function fullName(p) {
            return p.present ? p.name : p.name + "__" + p.multiplexConfigurationId;
        }
        for (var i = 0; i < exportedDeps.length; ++i)
            exportedDepNames.push(fullName(exportedDeps[i]));
        if (considerPrivate) {
            for (i = 0; i < (productOrModule.dependencies || []).length; ++i) {
                var dep = productOrModule.dependencies[i];
                if (!exportedDepNames.contains(fullName(dep)))
                    privateDeps.push(dep);
            }
        }

        if (!privateContext)
            exportedDeps.forEach(function(dep) { collectLibrariesRecursive(dep, privateContext); });
        privateDeps.forEach(function(dep) { collectLibrariesRecursive(dep, true); });
    }

    collectLibrariesRecursive(topLevelProduct, false);
    return publicLibs.uniqueConcat(privateLibs); // TODO: Probably needs to be smarter
}
