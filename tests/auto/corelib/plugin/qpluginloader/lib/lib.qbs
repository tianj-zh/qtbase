import qbs

QtAutotestAuxBinary {
    name: "tst_qpluginloaderlib"
    condition: base && project.theCondition
    binaryType: "dynamiclibrary"
    installSuffix: "bin"

    Depends { name: "Qt.core" }

    Properties {
        condition: qbs.toolchain.contains("msvc")
        cpp.defines: base.concat("WIN32_MSVC")
    }

    files: "mylib.c"
}
