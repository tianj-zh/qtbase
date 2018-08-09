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

/*
android {
    libs.prefix = android_test_data
    libs.base = $$OUT_PWD/..
    libs.files += $$OUT_PWD/../libmylib.so             \
                  $$OUT_PWD/../libmylib.so2            \
                  $$OUT_PWD/../libmylib.prl            \
                  $$OUT_PWD/../system.qt.test.mylib.so

    RESOURCES += libs
}
*/
