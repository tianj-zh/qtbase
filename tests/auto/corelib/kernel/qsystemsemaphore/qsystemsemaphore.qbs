import qbs

Project {
    references: "acquirerelease"

    QtAutotest {
        name: "tst_qsystemsemaphore"
        condition: base && !qbs.targetOS.contains("android") && Qt.core.config.systemsemaphore
        consoleApplication: true
        files: "tst_qsystemsemaphore.cpp"
    }
}
