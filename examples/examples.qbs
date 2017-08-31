import qbs
import qbs.File
import qbs.FileInfo

Project {
    name: "examples"
    Probe {
        id: subProjectsProbe
        property stringList subProjectFilePaths
        configure: {
            var projectFiles = [];
            var dirs = File.directoryEntries(path, File.Dirs);
            for (var i = 0; i < dirs.length; ++i) {
                var candidate = FileInfo.joinPaths(path, dirs[i], dirs[i] + ".qbs");
                if (File.exists(candidate))
                    projectFiles.push(candidate);
            }
            subProjectFilePaths = projectFiles;
            found = true;
        }
    }
    references: subProjectsProbe.subProjectFilePaths
}
