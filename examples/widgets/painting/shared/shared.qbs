import qbs

Group {
    name: "shared sources"
    prefix: path + "/"

    files: [
        "arthurstyle.cpp",
        "arthurstyle.h",
        "arthurwidgets.cpp",
        "arthurwidgets.h",
        "hoverpoints.cpp",
        "hoverpoints.h",
        "shared.qrc",
    ]
}
