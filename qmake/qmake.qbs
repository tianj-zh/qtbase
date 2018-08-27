import qbs

QtHostTool {
    useBootstrapLib: true
    cpp.defines: ["QT_BUILD_QMAKE", "QT_BOOTSTRAPPED", "PROEVALUATOR_FULL", "QT_NO_FOREACH",
        'QT_VERSION_STR="' + project.version + '"',
        "QT_VERSION_MAJOR=" + project.versionParts[0],
        "QT_VERSION_MINOR=" + project.versionParts[1],
        "QT_VERSION_PATCH=" + project.versionParts[2],
    ]
    Properties {
        condition: qbs.targetOS.contains("windows")
        cpp.defines: outer.concat("UNICODE", "_CRT_SECURE_NO_WARNINGS", "_SCL_SECURE_NO_WARNINGS")
    }
    cpp.includePaths: [
        ".", "library", "generators", "generators/unix", "generators/win32", "generators/mac",
        project.configPath,
    ]
    Group {
        name: "Qt sources"
        prefix: "../src/corelib/"
        files: [
            "global/qlibraryinfo.cpp",
            "io/qsettings.cpp",
            "io/qsettings.h",
        ]
        Group {
            condition: qbs.targetOS.contains("macos")
            name: "Qt sources (macOS)"
            files: "io/qsettings_mac.cpp"
        }
        Group {
            condition: qbs.targetOS.contains("windows")
            name: "Qt sources (Windows)"
            files: "io/qsettings_win.cpp"
        }
    }
    Group {
        name: "pch"
        files: "qmake_pch.h"
        fileTags: "cpp_pch_src"
    }
    files: [
        "cachekeys.h",
        "generators/mac/pbuilder_pbx.cpp",
        "generators/mac/pbuilder_pbx.h",
        "generators/makefile.cpp",
        "generators/makefile.h",
        "generators/makefiledeps.cpp",
        "generators/makefiledeps.h",
        "generators/metamakefile.cpp",
        "generators/metamakefile.h",
        "generators/projectgenerator.cpp",
        "generators/projectgenerator.h",
        "generators/unix/unixmake.cpp",
        "generators/unix/unixmake.h",
        "generators/unix/unixmake2.cpp",
        "generators/win32/mingw_make.cpp",
        "generators/win32/mingw_make.h",
        "generators/win32/msbuild_objectmodel.cpp",
        "generators/win32/msbuild_objectmodel.h",
        "generators/win32/msvc_nmake.cpp",
        "generators/win32/msvc_nmake.h",
        "generators/win32/msvc_objectmodel.cpp",
        "generators/win32/msvc_objectmodel.h",
        "generators/win32/msvc_vcproj.cpp",
        "generators/win32/msvc_vcproj.h",
        "generators/win32/msvc_vcxproj.cpp",
        "generators/win32/msvc_vcxproj.h",
        "generators/win32/winmakefile.cpp",
        "generators/win32/winmakefile.h",
        "generators/xmloutput.cpp",
        "generators/xmloutput.h",
        "library/ioutils.cpp",
        "library/ioutils.h",
        "library/proitems.cpp",
        "library/proitems.h",
        "library/qmake_global.h",
        "library/qmakebuiltins.cpp",
        "library/qmakeevaluator.cpp",
        "library/qmakeevaluator.h",
        "library/qmakeevaluator_p.h",
        "library/qmakeglobals.cpp",
        "library/qmakeglobals.h",
        "library/qmakeparser.cpp",
        "library/qmakeparser.h",
        "library/qmakevfs.cpp",
        "library/qmakevfs.h",
        "main.cpp",
        "meta.cpp",
        "meta.h",
        "option.cpp",
        "option.h",
        "project.cpp",
        "project.h",
        "property.cpp",
        "property.h",
    ]
    Group {
        name: "Windows sources"
        condition: qbs.targetOS.contains("windows")
        files: "generators/win32/registry.cpp"
    }
}
