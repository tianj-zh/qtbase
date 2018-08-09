import qbs

Project {
    references: "producerconsumer"

    QtAutotest {
        name: "tst_qsharedmemory"
        condition: base && Qt.core.config.sharedmemory && Qt.global.privateConfig.private_tests
            && !qbs.targetOS.contains("android")
        Depends { name: "Qt.core_private" }
        Properties {
            condition: qbs.targetOS.contains("linux")
            cpp.dynamicLibraries: base.concat("rt")
        }
        files: "tst_qsharedmemory.cpp" }
}
