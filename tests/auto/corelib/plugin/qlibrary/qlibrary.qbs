import qbs

Project {
    references: [
        "lib",
        "lib2",
    ]

    QtAutotest {
        name: "tst_qlibrary"
        condition: base && Qt.core.config.library

        Depends { name: "mylib"; cpp.link: false }
        Depends { name: "mylib2"; cpp.link: false }

        files: "tst_qlibrary.cpp"

        QtTestData {
            files: "library_path/invalid.so"
        }
    }
}
