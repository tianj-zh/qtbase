import qbs

QtAutotestPlugin {
    condition: base && Qt.core.config.library
               && !qbs.targetOS.contains("windows") || qbs.buildVariant === "debug"
    qbs.buildVariant: "debug"
    files: "main.cpp"
}
