import qbs

QtAutotestHelperApp {
    targetName: "acquirerelease_helper"
    consoleApplication: true
    installSuffix: ""

    Depends { name: "Qt.core" }
    Depends { name: "Qt.testlib" }
    Depends { name: "osversions" }

    files: "main.cpp"
}
