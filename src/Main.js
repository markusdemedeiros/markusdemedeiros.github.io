"use strict";


exports.clearById = x => () => {
    let ret = document.getElementById(x).value;
    document.getElementById(x).value = '';
    return ret;
}


exports.setById = x => s => () => {
    document.getElementById(x).value = s;
}
