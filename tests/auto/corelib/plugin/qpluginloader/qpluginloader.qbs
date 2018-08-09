import qbs
import QtGlobalConfig
import QtCoreConfig

Project {
    property bool theCondition: QtCoreConfig.library
    references: [
        "almostplugin",
        "lib",
        "machtest",
        "theplugin",
    ]

    QtAutotest {
        name: "tst_qpluginloader"
        condition: base && project.theCondition

        Depends { name: "Qt.core_private"; condition: Qt.global.privateConfig.private_tests }

        Depends { name: "tst_qpluginloaderlib"; cpp.link: false }
        Depends { name: "theplugin" }
        Depends { name: "almostplugin"; required: false }

        files: [
            "fakeplugin.cpp",
            "theplugin/plugininterface.h",
            "tst_qpluginloader.cpp",
        ]

        QtTestData {
            files: "elftest/*"
        }
    }
}
