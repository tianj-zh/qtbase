import qbs

QtAutotestHelperApp {
    consoleApplication: true

    Depends { name: "Qt.core" }

    files: "main.cpp"
}
