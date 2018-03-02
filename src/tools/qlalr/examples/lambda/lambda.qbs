import qbs

CppApplication {
    name: "qlalr_lambda_example"
    consoleApplication: true
    Depends { name: "qlalr" }
    Depends { name: "Qt.core" }
    files: [
        "lambda.g",
        "main.cpp",
    ]
}
