import qbs

Project {
    name: "examples (actual products)"
    qbsSearchPaths: [
        ".",
        project.qtbaseShadowDir + "/src/corelib/qbs", // For QtCoreConfig.
        project.qtbaseShadowDir + "/src/gui/qbs", // For QtGuiConfig.
        project.qtbaseShadowDir + "/src/network/qbs", // For QtNetworkConfig.
    ]
    references: [
        "corelib/corelib.qbs",
        "dbus/dbus.qbs",
//        "embedded/embedded.qbs",
        "gui/gui.qbs",
        "network/network.qbs",
//        "opengl/opengl.qbs",
//        "qpa/qpa.qbs",
        "qtconcurrent/qtconcurrent.qbs",
        "qtestlib/qtestlib.qbs",
//        "sql/sql.qbs",
//        "touch/touch.qbs",
        "widgets/widgets.qbs",
        "xml/xml.qbs",
    ]
}
