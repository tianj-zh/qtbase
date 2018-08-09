import qbs

QtAutotestHelperApp {
    targetName: "echo_helper"
    installSuffix: ""
    Depends { name: "Qt.core" }
    files: "main.cpp"
}
