var TextFile = require("qbs.TextFile");

function parseGrammar(filePath) {
    var g = {};
    g.parser = "parser_table";
    var reDecl = /^%decl\s+(.*)$/;
    var reImpl = /^%impl\s+(.*)$/;
    var reParser = /^%parser\s+(.*)$/;
    var reMergedOutput = /^%merged_output\s+(.*)$/;
    var reStart = /^%start\s+.*$/;
    var f = new TextFile(filePath);
    while (!f.atEof()) {
        var line = f.readLine();
        var r;
        if (r = reDecl.exec(line)) {
            g.decl = r[1];
        } else if (r = reImpl.exec(line)) {
            g.impl = r[1];
        } else if (r = reParser.exec(line)) {
            g.parser = r[1];
        } else if (r = reMergedOutput.exec(line)) {
            g.merged = r[1];
        } else if (reStart.exec(line)) {
            // Nothing below %start is of interest for us.
            break;
        }
    }
    f.close();
    return g;
}
