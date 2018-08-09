import qbs

QtAutotestHelperApp {
    targetName: "signalbug_helper"
    condition: !targetsUWP
    consoleApplication: true
    installSuffix: ""

    Depends { name: "Qt.core" }

    files: [
        "signalbug.cpp",
        "signalbug.h",
    ]
}
