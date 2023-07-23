async function loadModule(file) {
    var response;
    try {
        response = await fetch(file + '/info.txt');
    } catch(error) {return ['Error']}
    if (response.status == 200) {
        const jsCode = await response.text();
        lst = jsCode.split('\n');
        title = lst[0].substring(lst[0].indexOf('\"') + 1, lst[0].lastIndexOf('\"'));
        n = lst[3].replace(']', '').replace('[', '').split(', ').map(x => parseInt(x));
        return [200, lst[0].replaceAll('"', '') + '\n' + lst[1] + '\n' + lst[2] + '\n' + lst[3].replaceAll(' ', '') + '\n' + lst[4].replaceAll(' ', '') + '\n', n, title];
    } else {return [response.status];}
}

async function get_code(file, ques, type) {
    var response = await fetch(file + '/' + type + ques + '.svg');
    svgcode = await response.text();
}

async function fill_svg(file) {
    var arr = [];
    let res = await loadModule(file);
    if (res[0] == 200) {
        for (let i = 0; i < res[2].length; i++) {
            await get_code(file, res[2][i], 'Q');
            arr[2*res[2][i]-2] = svgcode;
            await get_code(file, res[2][i], 'R');
            arr[2*res[2][i]-1] = svgcode;
        }
    } else {
        return [undefined, undefined];
    }
    return [res[1] + arr.map((x,i,a) => x.replaceAll('\r', '').replaceAll('\n', '')).map(x => encodeURIComponent(x)).join('\n') + '\n', res[3]];
}

function absolute(rel) {
    var link = document.createElement("a");
    link.href = rel;
    return (link.protocol + "//" + link.host + link.pathname);
}

function download_text(start, title, file, filename) {
    var date = new Date;
    console.log(start);
    var time = date.getFullYear() + String(date.getMonth() + 1).padStart(2, '0') + String(date.getDate()).padStart(2, '0') + String(date.getHours()).padStart(2, '0') + String(date.getMinutes()).padStart(2, '0') + String(date.getSeconds()).padStart(2, '0');
    var text = start + time + '\n' + btoa(title) + '\n' + absolute(file + (title.includes('&ndash;')?'/../..':'/..')) + 'cards.txt' + '\n' + filename;
    return [compress_text(text), time];

}

async function sync(url, name) {
    try {
        response = await fetch(url);
    } catch(error) {window.alert('Impossible de rafraîchir le fichier.');}
    if (response.status == 200) {
        const jsCode = await response.text();
        let ls = jsCode.split('\n'); let found = false;
        for (let i = 0; i < (ls.length - 1)/2; ++i) {
            if (ls[2*i + 1] == name) {
                if (parseInt(ls[2*i + 2]) > read_date(url, name)) {
                    window.alert('Une mise à jour est disponible et va être chargée.');
                    await delete_card(url, name);
                    add_card(url, name, absolute(ls[0]+ls[2*i+1]), undefined)
                } else {window.alert('Le fichier est à jour.')}
                found = true;
                break;
            }
        }
        if (!found) {window.alert('Le fichier n\'est pas disponible.')}
    } else {window.alert('Impossible de rafraîchir le fichier.');}
}

async function downcrd(url,fl) {
    let [start, title] = await fill_svg(url);
    if (start !== undefined) {
        let txt = download_text(start, title, url, fl);
        return txt;
    } else {
        return undefined;
    }
}