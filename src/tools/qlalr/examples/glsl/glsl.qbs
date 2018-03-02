import qbs

CppApplication {
    name: "qlalr_glsl_example"
    consoleApplication: true
    Depends { name: "qlalr" }
    Depends { name: "Qt.core" }
    Depends { name: "lex_yacc" }
    lex_yacc.lexOutputFilePath: "glsl-lex.incl"
    lex_yacc.outputTag: "hpp"
    cpp.includePaths: [buildDirectory + "/lexyacc"]
    files: [
        "glsl-lex.l",
        "glsl.g",
    ]
}
