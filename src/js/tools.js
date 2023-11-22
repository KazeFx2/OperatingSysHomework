.pragma library

function format() {
    if (arguments.length === 0) {
        return "";
    }
    var s = arguments[0]
    for (var i = 1; i < arguments.length; i++) {
        s = s.replace(new RegExp("\\{" + (i - 1) + "\\}", "g"), arguments[i]);
    }
    return s;
}
