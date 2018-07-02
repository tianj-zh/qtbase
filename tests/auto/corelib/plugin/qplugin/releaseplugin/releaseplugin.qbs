import qbs

QtAutotestPlugin {
    condition: base && Qt.core.config.library
               && !qbs.targetOS.contains("windows") || qbs.buildVariant === "release"
    qbs.buildVariant: "release"
    files: "main.cpp"
}
