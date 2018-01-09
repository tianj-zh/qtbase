import qbs
import qbs.Process
import qbs.TextFile

import QtGlobalConfig
import QtGlobalPrivateConfig
import QtUtils

import "pri_helpers.js" as PriHelpers

Module {
    additionalProductTypes: ["qt.pri"]

    property string priName: {
        if (product.name.endsWith("private"))
            return project.simpleName + "_private";
        return project.simpleName;
    }
    property string fileName: "qt_lib_" + priName + ".pri"

    property bool isPrivateShadowModule: false
    property stringList config
    property stringList uses
    property string masterHeader

    Rule {
        // There's only one such file per Qt module, even if it is multiplexed.
        condition: !QtGlobalConfig.debug_and_release || qbs.buildVariant === "release"
                   || isPrivateShadowModule

        multiplex: true
        Artifact {
            filePath: product.qt_module_pri.fileName
            fileTags: ["qt.pri"]
            qbs.install: true
            qbs.installDir: "mkspecs/modules"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                var ver = project.version;
                PriHelpers.writeValue(file, product, "VERSION", ver);
                PriHelpers.writeValue(file, product, "name", project.name);
                PriHelpers.writeValue(file, product, "module",
                                      product.qt_module_pri.isPrivateShadowModule
                                          ? "" : product.targetName);
                PriHelpers.writeValue(file, product, "libs", product.hostBuild
                                      ? "$$QT_MODULE_HOST_LIB_BASE" : "$$QT_MODULE_LIB_BASE");

                if (product.qt_module_pri.masterHeader) {
                    PriHelpers.writeValue(file, product, "master_header",
                                          product.qt_module_pri.masterHeader);
                }

                var includes = product.exports.cpp.includePaths || [];
                includes.forEach(function(v, i, a) {
                    a[i] = v.replace(product.qbs.installPrefix + "/include",
                                     "$$$$QT_MODULE_INCLUDE_BASE");
                });
                PriHelpers.writeValue(file, product, "includes", includes);

                var frameworkVal = product.bundle && product.bundle.isBundle
                        ? "$$QT_MODULE_LIB_BASE" : "";
                PriHelpers.writeValue(file, product, "frameworks", frameworkVal);

                if (!product.hostBuild && !product.qt_module_pri.isPrivateShadowModule)
                    PriHelpers.writeValue(file, product, "bins", "$$QT_MODULE_BIN_BASE");
                if (!product.hostBuild && Array.isArray(product.pluginTypes)
                        && product.pluginTypes.length > 0) {
                    PriHelpers.writeValue(file, product, "plugin_types", product.pluginTypes);
                }

                var deps = [];
                for (var i = 0; i < product.exports.dependencies.length; ++i)
                    PriHelpers.handleDependency(product.exports.dependencies[i], deps, []);
                PriHelpers.writeValue(file, product, "depends", deps.join(" "));

                // FIXME: The run dependencies aren't quite right yet.
                if (!product.qt_module_pri.isPrivateShadowModule) {
                    var runDeps = [];
                    for (i = 0; i < product.dependencies.length; ++i)
                        PriHelpers.handleDependency(product.dependencies[i], runDeps, deps);
                    if (!project.internal)
                        runDeps.push(product.name.slice(3) + "_private");
                    if (runDeps.length > 0)
                        PriHelpers.writeValue(file, product, "run_depends", runDeps.join(" "));
                }

                PriHelpers.writeValue(file, product, "uses", product.qt_module_pri.uses || [])
                var moduleConfig = "v2";
                if (product.type.contains("staticlibrary")
                        || (product.qt_module_pri.isPrivateShadowModule
                            && QtGlobalConfig.staticBuild)) {
                    moduleConfig += " staticlib";
                }
                if (product.bundle && product.bundle.isBundle)
                    moduleConfig += " lib_bundle";
                if (project.internal || product.qt_module_pri.isPrivateShadowModule)
                    moduleConfig += " internal_module";
                if (QtGlobalPrivateConfig.ltcg)
                    moduleConfig += " ltcg";
                PriHelpers.writeValue(file, product, "module_config", moduleConfig);

                if (product.qbs.targetOS.contains("integrity") && product.cpp.enableExceptions)
                    config.push("exceptions");
                if (product.qt_module_pri.config && product.qt_module_pri.config.length > 0)
                    PriHelpers.writeValue(file, product, "CONFIG", product.qt_module_pri.config);

                if (!product.qt_module_pri.isPrivateShadowModule) {
                    var cppDefines = product.exports.cpp ? product.exports.cpp.defines : [];
                    cppDefines = cppDefines.map(function(val) {
                        return QtUtils.qmakeQuote(Process.shellQuote(val, []));
                    });
                    PriHelpers.writeValue(file, product, "DEFINES", cppDefines);
                }

                var config = product.config;
                PriHelpers.writeValue(file, product, "enabled_features",
                                      config ? config.enabled_features : "");
                PriHelpers.writeValue(file, product, "disabled_features",
                                      config ? config.disabled_features : "");
                if (!product.qt_module_pri.isPrivateShadowModule) {
                    PriHelpers.writeValue(file, product, "QT_CONFIG",
                                          config ? config.qtConfig : "", "", "+=");
                }

                if (config) {
                    var writeIfNonEmpty = function(varName, value) {
                        if (value.length > 0) {
                            PriHelpers.writeValue(file, product, varName,
                                                  QtUtils.qmakeQuote(value), "");
                        }
                    };
                    for (var lib in config.libsMap) {
                        var libNameUpper = lib.toUpperCase();
                        PriHelpers.writeValue(file, product, "QMAKE_LIBS_" + libNameUpper,
                                              QtUtils.qmakeQuote(config.libsMap[lib].libs), "");
                        writeIfNonEmpty("QMAKE_LIBS_" + libNameUpper + "_RELEASE",
                                        config.libsMap[lib].releaseLibs);
                        writeIfNonEmpty("QMAKE_LIBS_" + libNameUpper + "_DEBUG",
                                        config.libsMap[lib].debugLibs);
                        writeIfNonEmpty("QMAKE_DEFINES_" + libNameUpper,
                                        config.libsMap[lib].defines);
                        writeIfNonEmpty("QMAKE_INCDIR_" + libNameUpper,
                                        config.libsMap[lib].includes);
                    }
                    for (var exportVal in config.exportsMap) {
                        PriHelpers.writeValue(file, product, exportVal, QtUtils.qmakeQuote(
                                                  config.exportsMap[exportVal]), "");
                    }
                }
                if (product.targetsUWP) {
                    PriHelpers.writeValue(file, product, "winrt_capabilities",
                                          product.winrtCapabilities || []);
                    PriHelpers.writeValue(file, product, "winrt_capabilities_device",
                                          product.winrtCapabilitiesDevice || []);
                }

                if (!product.qt_module_pri.isPrivateShadowModule)
                    file.writeLine("QT_MODULES += " + project.simpleName);
                file.close();
            }
            return [cmd];
        }
    }
}
