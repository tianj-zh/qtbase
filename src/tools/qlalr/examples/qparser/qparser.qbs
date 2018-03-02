import qbs

CppApplication {
    name: "qlalr_qparser_example"
    condition: !qbs.toolchain.contains("msvc")
    consoleApplication: true
    Depends { name: "qlalr" }
    Depends { name: "Qt.core" }
    Depends { name: "lex_yacc" }
    lex_yacc.outputTag: "cpp"
    cpp.includePaths: ["."]
    files: [
        "calc.g",
        "calc.l",
        "qparser.cpp",
        "qparser.h",
    ]
}
