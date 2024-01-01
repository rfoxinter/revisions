async function loadModule(file) {
    var response;
    try {
        response = await fetch(file + '/info.txt');
    } catch {return [];}
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

function enc_title(text) {
    return text.replaceAll('\u2019', '````2019````')
}
function dec_title(text) {
    return text.replaceAll('````2019````', '\u2019')
}

function download_text(start, title, file, filename) {
    var date = new Date;
    var time = date.getFullYear() + String(date.getMonth() + 1).padStart(2, '0') + String(date.getDate()).padStart(2, '0') + String(date.getHours()).padStart(2, '0') + String(date.getMinutes()).padStart(2, '0') + String(date.getSeconds()).padStart(2, '0');
    var text = enc_title(start) + time + '\n' + btoa(enc_title(title)) + '\n' + absolute(file + (title.includes('&ndash;')?'/../..':'/..')) + 'cards.txt' + '\n' + filename;
    return [compress_text(text), time];

}

async function sync(url, name, message = true) {
    try {
        response = await fetch(url);
    } catch(error) {if (message) {window.alert('Impossible de rafraîchir le fichier');}}
    if (response.status == 200) {
        const jsCode = await response.text();
        let ls = jsCode.split('\n'); let found = false;
        for (let i = 0; i < (ls.length - 1)/2; ++i) {
            if (ls[2*i + 1] == name) {
                if (parseInt(ls[2*i + 2]) > await read_date(url, name)) {
                    window.alert('Une mise à jour est disponible et va être téléchargée');
                    let card = document.getElementById('[' + url + ',' + name + ']').getElementsByTagName('a');
                    let href = [];
                    for (let i = 0; i < card.length; ++i) {
                        href.push(card[i].href);
                        card[i].style.filter = 'grayscale(100%)';
                        card[i].href = 'javascript:void(0);'
                        
                    }
                    await delete_card(url, name, false);
                    await add_card(url, name, absolute(ls[0]+ls[2*i+1]), undefined);
                    for (let i = 0; i < card.length; ++i) {
                        card[i].style.filter = '';
                        card[i].href = href[i];
                    }
                    window.alert('Mise à jour téléchargée');
                } else {if (message) {window.alert('Le fichier est à jour.');}}
                found = true;
                break;
            }
        }
        if (!found) {if (message) {window.alert('Le fichier n\'est pas disponible');}}
    } else {if (message) {window.alert('Impossible de rafraîchir le fichier');}}
}

async function sync_upload(name) {
    var card = await read_card("Fichiers importés", name);
    var file = await deflate(card).split('\n');
    var n = file[3].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
    var filedate = parseInt(file[5+2*n.length]);
    var syncurl = file[7+2*n.length];
    var filename = file[8+2*n.length];
    try {
        response = await fetch(syncurl);
    } catch(error) {window.alert('Impossible de rafraîchir le fichier');}
    if (response.status == 200) {
        const jsCode = await response.text();
        let ls = jsCode.split('\n'); let found = false;
        for (let i = 0; i < (ls.length - 1)/2; ++i) {
            if (ls[2*i + 1] == atob(filename)) {
                if (parseInt(ls[2*i + 2]) > filedate) {
                    window.alert('Une mise à jour est disponible et va être téléchargée');
                    let card = document.getElementById('[Fichiers importés,' + name + ']').getElementsByTagName('a');
                    let href = [];
                    for (let i = 0; i < card.length; ++i) {
                        href.push(card[i].href);
                        card[i].style.filter = 'grayscale(100%)';
                        card[i].href = 'javascript:void(0);'
                        
                    }
                    await download_upload(file, n, absolute(ls[0] + ls[2*i + 1]));
                    for (let i = 0; i < card.length; ++i) {
                        card[i].style.filter = '';
                        card[i].href = href[i];
                    }
                    window.alert('Mise à jour téléchargée');
                } else {window.alert('Le fichier est à jour')}
                found = true;
                break;
            }
        }
        if (!found) {window.alert('Le fichier n\'est pas disponible')}
    } else {window.alert('Impossible de rafraîchir le fichier');}
}

function absolute(rel) {
    var link = document.createElement("a");
    link.href = rel;
    return (link.protocol + "//" + link.host + link.pathname);
}

async function down_svg_upload(file, len) {
    var arr = [];
    for (let i = 0; i < len; i++) {
        await get_code(file, i + 1, 'Q');
        arr[2*i] = svgcode;
        await get_code(file, i + 1, 'R');
        arr[2*i + 1] = svgcode;
    }
    return arr;
}

async function download_upload(file, n, fileurl) {
    var response; var lst;
    try {
        response = await fetch(fileurl + '/info.txt');
    } catch(error) {window.alert('Impossible de rafraîchir le fichier'); return;}
    if (response.status == 200) {
        const jsCode = await response.text();
        lst = jsCode.split('\n');
    } else {window.alert('Impossible de rafraîchir le fichier'); return;}
    var n = lst[3].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
    var filename = file[8+2*n.length];
    file = file[7+2*n.length];
    var date = new Date;
    var arr = await down_svg_upload(fileurl, n.length);
    var text = lst[0].replaceAll('"', '') + '\n' + lst[1] + '\n' + lst[2] + '\n' + lst[3].replaceAll(' ', '') + '\n' + lst[4].replaceAll(' ', '') + '\n' + arr.map((x,i,a) => x.replaceAll('\r', '').replaceAll('\n', '')).map(x => encodeURIComponent(x)).join('\n') + '\n' + date.getFullYear() + String(date.getMonth() + 1).padStart(2, '0') + String(date.getDate()).padStart(2, '0') + String(date.getHours()).padStart(2, '0') + String(date.getMinutes()).padStart(2, '0') + String(date.getSeconds()).padStart(2, '0') + '\n' + btoa(lst[0].replaceAll('"', '')) + '\n' + file + '\n' + filename;
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readwrite");
        var store = tx.objectStore("flcrd");

        store.put({url: "Fichiers importés", name: lst[0].replaceAll('"', ''), content: compress_text(text)});
        window.alert("Fiche mise à jour");

        tx.oncomplete = function() {
            db.close();
        };
    };
}

async function downcrd(url,fl) {
    let [start, title] = await fill_svg(url);
    if (start !== undefined) {
        let txt = download_text(start, title, url, fl);
        txt.push(title);
        return txt;
    } else {
        return undefined;
    }
}