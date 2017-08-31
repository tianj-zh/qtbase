import qbs
import qbs.FileInfo

CppApplication {
    name: "i18n"
    condition: Qt.widgets.present && Qt.core.config.translation && Qt.widgets.config.listwidget

    Depends { name: "Qt.core" }
    Depends { name: "Qt.widgets"; required: false }

    files: [
        "i18n.qrc",
        "languagechooser.cpp",
        "languagechooser.h",
        "main.cpp",
        "mainwindow.cpp",
        "mainwindow.h",
    ]

    Group {
        name: "translations"
        prefix: "translations/"
        files: [
            "i18n_ar.ts",
            "i18n_cs.ts",
            "i18n_de.ts",
            "i18n_el.ts",
            "i18n_en.ts",
            "i18n_eo.ts",
            "i18n_fr.ts",
            "i18n_it.ts",
            "i18n_jp.ts",
            "i18n_ko.ts",
            "i18n_no.ts",
            "i18n_ru.ts",
            "i18n_sv.ts",
            "i18n_zh.ts",
        ]
    }

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "tools",
                                           "i18n")
    }
}
