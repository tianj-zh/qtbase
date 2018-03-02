import qbs

CppApplication {
    name: "qlalr_xml_example"
    consoleApplication: true
    Depends { name: "qlalr" }
    Depends { name: "Qt.core" }
    files: [
        "xml.g",
    ]
}
