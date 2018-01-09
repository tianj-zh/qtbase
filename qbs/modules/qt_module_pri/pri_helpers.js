function handleDependency(dep, allDepNames, blacklist) {
    if (dep.qt_module_pri) {
        depName = dep.name.slice(3).replace("-private", "_private");
        if (!allDepNames.contains(depName) && !blacklist.contains(depName))
            allDepNames.push(depName);
    }
    if (!dep.exports)
        return;
    for (var i = 0; i < dep.exports.dependencies.length; ++i)
        handleDependency(dep.exports.dependencies[i], allDepNames, blacklist);
}

function writeValue(file, product, key, value, prefix, operator) {
    var actualPrefix = prefix;
    if (actualPrefix === undefined)
        actualPrefix = "QT." + product.qt_module_pri.priName + '.';
    if (operator === undefined)
        operator = "=";
    if (Array.isArray(value))
        value = value.join(' ');
    file.writeLine(actualPrefix + key + ' ' + operator + (value ? ' ' + value : ""));
};
