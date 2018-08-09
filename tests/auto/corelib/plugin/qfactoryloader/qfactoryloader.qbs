import qbs

Project {
    references: [
        "plugin1",
        "plugin2",
    ]

    QtAutotest {
        name: "tst_qfactoryloader"
        condition: base && !Qt.core.config.staticBuild

        Depends { name: "Qt.core" }
        Depends { name: "Qt.core_private" }

        Depends { name: "plugin1"; cpp.link: !Qt.core.config.library }
        Depends { name: "plugin2"; cpp.link: !Qt.core.config.library }

        files: [
            "plugin1/plugininterface1.h",
            "plugin2/plugininterface2.h",
            "tst_qfactoryloader.cpp",
        ]
    }
}

/*
android {
    libs.prefix = android_test_data
    libs.base = $$OUT_PWD/..
    libs.files += $$OUT_PWD/../bin

    RESOURCES += libs
}
*/
