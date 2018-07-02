import qbs
import qbs.FileInfo
import QtMultiplexConfig

QtAutotestAuxBinary {
    type: ["application", "autotest-helper"]
    consoleApplication: true

    binaryType: "application"
    Group {
        fileTagsFilter: "application"
        fileTags: "autotest-helper"

        // TODO: Remove these once we require qbs 1.13
        qbs.install: doInstall
        qbs.installDir: installDir
    }
}
