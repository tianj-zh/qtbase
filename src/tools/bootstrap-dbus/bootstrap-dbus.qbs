import qbs

QtModuleProject {
    name: "QtBootstrapDBus"
    simpleName: "bootstrap_dbus"
    internal: true

    QtModule {
        condition: Qt.global.privateConfig.dbus
            && (Qt.global.config.cross_compile || Qt.global.privateConfig.private_tests)
        hostBuild: true
        Properties {
            condition: Qt.global.config.release_tools
            qbs.buildVariant: "release"
        }
        qbs.buildVariant: original

        Properties {
            condition: createPkgconfigFiles
            Exporter.pkgconfig.excludedDependencies: ["Qt.core"]
        }

        // Ignore debug_and_release for host tools.
        multiplexByQbsProperties: base.filter(function(name) { return name !== "buildVariants"; })

        Export {
            Depends { name: "Qt.dbus_headers" }
            Depends { name: "cpp" }
            cpp.includePaths: project.includePaths.concat(Qt.dbus_headers.includePaths)
        }

        Depends { name: "Qt.bootstrap_private" }
        Depends { name: "Qt.dbus_headers" }

        cpp.includePaths: base.concat(project.includePaths, Qt.dbus_headers.includePaths)
        cpp.defines: base.concat("QT_NO_FOREACH", "QT_NO_CAST_FROM_ASCII")
        cpp.cxxFlags: base.concat(Qt.global.privateConfig.dbus_host_cflags)

        Group {
            prefix: "../../dbus/"
            files: [
                "qdbus_symbols.cpp",
                "qdbusargument.cpp",
                "qdbuserror.cpp",
                "qdbusextratypes.cpp",
                "qdbusintrospection.cpp",
                "qdbusmetatype.cpp",
                "qdbusmisc.cpp",
                "qdbusunixfiledescriptor.cpp",
                "qdbusutil.cpp",
                "qdbusxmlparser.cpp",
            ]
        }
    }
}
