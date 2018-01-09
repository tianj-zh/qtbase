function includesForModule(module, base, qtVersion) {
    var includes = [base];
    if (module.endsWith("-private")) {
        module = module.slice(0, -8);
        includes.push(base + "/" + module + "/" + qtVersion);
        includes.push(base + "/" + module + "/" + qtVersion + "/" + module);
        includes.push(base + "/" + module + "/" + qtVersion + "/" + module + "/private");
        if (module === "QtGui")
            includes.push(base + "/" + module + "/" + qtVersion + "/" + module + "/qpa");
    }
    includes.push(base + '/' + module);
    return includes;
}

function qmakeMkspecToQbsModule(qmakeMkspec)
{
    if (qmakeMkspec.startsWith("win32-msvc") || qmakeMkspec.startsWith("winrt-"))
        return "Mkspec.msvc";
    if (qmakeMkspec.startsWith("android-"))
        return "Mkspec.android";
    if (qmakeMkspec.startsWith("linux-"))
        return "Mkspec.linux";
    if (qmakeMkspec === "devices/linux-rasp-pi3-g++")
        return "Mkspec.rasp_pi3";
}

function qmakeQuote(val)
{
    if (Array.isArray(val))
        return val.map(function(v) { return qmakeQuote(v); });
    var ret = "";
    if (!val)
        val = "";
    var l = val.length;
    var quote = l === 0;
    var escaping = false;
    for (var i = 0; i < l; i++) {
        var c = val[i];
        var uc = val.charCodeAt(i);
        if (uc < 32) {
            if (!escaping) {
                escaping = true;
                ret += "$$escape_expand(";
            }
            switch (uc) {
            case '\r':
                ret += "\\\\r";
                break;
            case '\n':
                ret += "\\\\n";
                break;
            case '\t':
                ret += "\\\\t";
                break;
            default:
                ret += uc.toString(16);
                break;
            }
        } else {
            if (escaping) {
                escaping = false;
                ret += ')';
            }
            switch (c) {
            case '\\':
                ret += "\\\\";
                break;
            case '"':
                ret += "\\\"";
                break;
            case '\'':
                ret += "\\'";
                break;
            case '$':
                ret += "\\$";
                break;
            case '#':
                ret += "$${LITERAL_HASH}";
                break;
            case ' ':
                quote = true; // Fall-through
            default:
                ret += c;
                break;
            }
        }
    }
    if (escaping)
        ret += ')';
    if (quote)
        ret = '"' + ret + '"';
    return ret;
}
