import qbs
import qbs.FileInfo

CppApplication {
    name: "savegame"
    consoleApplication: true
    Depends { name: "Qt.core" }
    files: [
        "character.cpp",
        "character.h",
        "game.cpp",
        "game.h",
        "level.cpp",
        "level.h",
        "main.cpp",
    ]
    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir,
                                           "corelib", "serialization", "savegame")
    }
}
