import qbs

QtAutotestHelperApp {
    targetName: "stdinprocess_helper"
    consoleApplication: true
    installSuffix: ""
    Depends { name: "Qt.core" }
    files: "main.cpp"
}
