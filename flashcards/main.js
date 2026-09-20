function shuffleArray(array) {
    for (let i = 0; i < array.length-1; ++i) {
        const j = Math.floor(Math.random() * (array.length));
        [array[i], array[j]] = [array[j], array[i]];
    }
}
function copyArray(array) {
    var cparr = new Array(array.length)
    for (let i = 0; i < array.length; ++i) {
        cparr[i] = array[i];
    }
    return cparr;
}
var title; var sh_quest; var sh_qr; var n; var ques; var fst; var q; var viewed; var nth; var svgcode; var arr = []; var wrong = []; var qr = [0, 1]; var lst; var fl; var syncurl; var filedate; var filename;
const params = new URLSearchParams(document.location.search.substring(1));
var file = params.get('file');
var card = params.get('card');
let start = '<!DOCTYPE html><html style="height: 100%;"><head style="height: 100%;"><meta charset="utf-8"><style>svg {max-width: 100%; max-height: 100% !important;fill: #606c71;width: unset !important;vertical-align: middle; scale: 2.5;}path:is(:not([fill]),[fill=none]):is(:not([stroke]),[stroke="#000"]) {stroke: #606c71;}path:is(:not([stroke]),[stroke=none]):is(:not([fill]),[fill="#000"]) {fill: #606c71;}* {-webkit-user-select: none; -ms-user-select: none; user-select: none;}body {margin: 0pt;} @media print {svg {fill: #000000 !important;}path:not([stroke],[fill]) {stroke: #000000 !important;} #flashcard {scale: 1 !important;} #flashcards_container {height: calc(max(25vh,150px)) !important;}}</style><script>document.addEventListener("contextmenu", (event) => {event.preventDefault();});</script></head><body style="height: 100%;"><div style="text-align: center; margin-bottom: 0rem; white-space: unset; height: 100%;"><span style="display: flex; align-items: center; justify-content: center; height: 100%;"><div style="height: 40%; max-width: 40%; display: flex; align-items: center;">';
let end = '</div></span></div></body></html>';
async function loadModule(file) {
    var response;
    try {
        response = await fetch(file + '/info.txt');
    } catch(error) {return 'Error'}
    if (response.status == 200) {
        const jsCode = await response.text();
        lst = jsCode.split('\n');
        title = lst[0].substring(lst[0].indexOf('\"') + 1, lst[0].lastIndexOf('\"'));
        sh_quest = parseInt(lst[1]);
        sh_qr = parseInt(lst[2]);
        n = lst[3].replace(']', '').replace('[', '').split(', ').map(x => parseInt(x));
        fst = lst[4].replace(']', '').replace('[', '').split(', ').map(x => parseInt(x));

        q = true;
        viewed = false;
        nth = 0;

        document.title = title.replace('&ndash;', '-').replace('<i>', '').replace('</i>', '');
        ques = copyArray(n);

        if (sh_quest) {shuffleArray(ques);}

        return 200;
    } else {return response.status;}
}
async function loadFile(file) {
    var response;
    try {
        response = await fetch(file);
    } catch(error) {return 'Error';}
    if (response.status == 200) {
        const jsCode = await response.text();
        fl = deflate(jsCode).split('\n');
        title = fl[0];
        sh_quest = parseInt(fl[1]);
        sh_qr = parseInt(fl[2]);
        n = fl[3].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
        fst = fl[4].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
        arr = new Array(2*n.length);
        for (let i = 0; i < 2*n.length; ++i) {
            arr[i] = decodeURIComponent(fl[5+i]);
        }
        filedate = parseInt(fl[5+2*n.length]);
        filename = fl[8+2*n.length];
        syncurl = fl[7+2*n.length];
        
        if (fl[6+2*n.length] != btoa(title)) {
            throw new Error('Fichier corrompu')
        }

        q = true;
        viewed = false;
        nth = 0;

        document.title = title.replace('&ndash;', '-').replace('<i>', '').replace('</i>', '');
        ques = copyArray(n);

        if (sh_quest) {shuffleArray(ques);}

        return 200;
    } else {return response.status;}
}
async function get_code(file, ques, type) {
    var response = await fetch(file + '/' + type + ques + '.svg');
    svgcode = await response.text();
}
async function fill_svg(file) {
    let res = await loadModule(file);
    if (res == 200) {
        arr = new Array(2*n.length);
        await get_code(file, ques[0], 'Q');
        arr[2*ques[0]-2] = svgcode;
        if (document.readyState !== "loading") {
            resume_loading(file);
        } else {
            document.addEventListener("DOMContentLoaded", (event) => {
                resume_loading(file);
            });
        }
    } else if (res == 'Error') {
        if (document.readyState !== "loading") {
            document.getElementById('up-button').style.display = 'none';
            document.getElementById('title').innerHTML = 'Erreur';
            document.getElementById('flashcard-front').innerHTML = 'Impossible de charger le fichier</br>Regarder le terminal (F12 puis &OpenCurlyQuote;Console&CloseCurlyQuote;) pour plus d\'informations';
        } else {
            document.addEventListener("DOMContentLoaded", (event) => {
                document.getElementById('up-button').style.display = 'none';
                document.getElementById('title').innerHTML = 'Erreur';
                document.getElementById('flashcard-front').innerHTML = 'Impossible de charger le fichier</br>Regarder le terminal (F12 puis &OpenCurlyQuote;Console&CloseCurlyQuote;) pour plus d\'informations';
            });
        }
    }
    else {
        if (document.readyState !== "loading") {
            document.getElementById('up-button').style.display = 'none';
            document.getElementById('title').innerHTML = 'Erreur ' + res;
            document.getElementById('flashcard-front').innerHTML = 'Fichier introuvable';
        } else {
            document.addEventListener("DOMContentLoaded", (event) => {
                document.getElementById('up-button').style.display = 'none';
                document.getElementById('title').innerHTML = 'Erreur ' + res;
                document.getElementById('flashcard-front').innerHTML = 'Fichier introuvable';
            });
        }
    }
}
async function resume_loading(file) {
    document.getElementById('up-button').style.display = 'none';
    document.getElementById('title').innerHTML = title;
    document.getElementById('flashcard-front').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[0]-2])) + end).replaceAll('=', '');
    document.getElementById('card_nb').innerHTML = nth + 1;
    document.getElementById('card_total').innerHTML = '/' + ques.length;
    document.getElementById('flip').disabled = false;
    await get_code(file, ques[0], 'R');
    document.getElementById('flip').disabled = false;
    arr[2*ques[0]-1] = svgcode;
    document.getElementById('flashcard-back').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[0]-1])) + end).replaceAll('=', '');
    for (let i = 1; i < n.length; i++) {
        await get_code(file, ques[i], 'Q');
        document.getElementById('flip').disabled = false;
        arr[2*ques[i]-2] = svgcode;
        await get_code(file, ques[i], 'R');
        document.getElementById('flip').disabled = false;
        arr[2*ques[i]-1] = svgcode;
    }
    document.getElementById('flip').disabled = false;
    document.getElementById('down-button').style.display = 'block';
    document.getElementById('up-button').style.display = 'block';
    document.getElementById('up-button').innerHTML = 'close';
    document.getElementById('up-button').setAttribute('onclick', '_close()');
}
async function fill_card(file) {
    let res = await loadFile(file);
    if (res == 200) {
        document.getElementById('flip').disabled = false;
        document.getElementById('title').innerHTML = title;
        document.getElementById('flashcard-front').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[0]-2])) + end).replaceAll('=', '');
        document.getElementById('down-button').style.display = 'block';
        document.getElementById('down-button').innerHTML = 'sync';
        document.getElementById('down-button').setAttribute('onclick', 'sync()');
        document.getElementById('card_nb').innerHTML = nth + 1;
        document.getElementById('card_total').innerHTML = '/' + ques.length;
    }
}
if (file != null && file != '') {
    fill_svg(atob(file));
    filename = file;
} else if (card != null && card != '') {
    fill_card(atob(card));
} else {
    document.getElementById('flip').disabled = true;
}
function reverse_card() {
    if (q) {
        // document.getElementById('flashcard').innerHTML = arr[2*ques[nth]-2+qr[Number(q)]];
        document.getElementById('flashcards-container').style.transform = 'rotateY(180deg)';
        document.getElementById('flip').innerHTML = 'Voir la question';
        q = false;
        viewed = true;
    } else {
        //document.getElementById('flashcard').innerHTML = arr[2*ques[nth]-2+qr[Number(q)]];
        document.getElementById('flashcards-container').style.transform = 'rotateY(0deg)';
        document.getElementById('flip').innerHTML = 'Voir la réponse';
        q = true;
    }
    if (viewed) {
        document.getElementById('incor').disabled = false;
        document.getElementById('corr').disabled = false;
    } else {
        document.getElementById('incor').disabled = true;
        document.getElementById('corr').disabled = true;
    }
}
function new_card(corr) {
    document.getElementById('flashcards-container').style.transform = 'rotateY(0deg)';
    if (nth + 1 == ques.length) {
        if (!corr) {wrong.push(ques[nth]);}
        nth += 1;
        document.getElementById('flashcard-front').innerHTML = 'Terminé';
        document.getElementById('flip').disabled = true;
        if (wrong.length > 0) {document.getElementById('incor').disabled = false;} else {document.getElementById('incor').disabled = true;}
        document.getElementById('corr').disabled = false;
        document.getElementById('incor').innerText = 'Revoir';
        document.getElementById('corr').innerText = 'Recommencer';
        document.getElementById('card_nb').innerHTML = '';
        document.getElementById('card_total').innerHTML = '';
    } else if (nth + 1 > ques.length) {
        document.getElementById('flip').disabled = false;
        document.getElementById('incor').innerText = 'Réponse incorrecte';
        document.getElementById('corr').innerText = 'Réponse correcte';
        if (!corr) {
            ques = copyArray(wrong);
            shuffleArray(ques);
            wrong = [];
            nth = 0;
            q = false;
            viewed = false;
            qr = [0, 1];
            if (sh_qr && !fst[ques[nth]-1]) {shuffleArray(qr);}
            reverse_card();
            document.getElementById('flashcard-front').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[nth]-2+qr[Number(!q)]])) + end).replaceAll('=', '');
            document.getElementById('flashcard-back').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[nth]-2+qr[Number(q)]])) + end).replaceAll('=', '');
        } else {
            ques = copyArray(n);
            shuffleArray(ques);
            wrong = [];
            nth = 0;
            q = false;
            viewed = false;
            qr = [0, 1];
            if (sh_qr && !fst[ques[nth]-1]) {shuffleArray(qr);}
            reverse_card();
            document.getElementById('flashcard-front').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[nth]-2+qr[Number(!q)]])) + end).replaceAll('=', '');
            document.getElementById('flashcard-back').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[nth]-2+qr[Number(q)]])) + end).replaceAll('=', '');
        }
        document.getElementById('card_nb').innerHTML = nth + 1;
        document.getElementById('card_total').innerHTML = '/' + ques.length;
    } else {
        if (!corr) {wrong.push(ques[nth]);}
        nth += 1;
        q = false;
        viewed = false;
        qr = [0, 1];
        if (sh_qr && !fst[ques[nth]-1]) {shuffleArray(qr);}
        reverse_card();
        document.getElementById('flashcard-front').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[nth]-2+qr[Number(!q)]])) + end).replaceAll('=', '');
        document.getElementById('flashcard-back').src = 'data:text/html;base64,' + btoa(start + unescape(encodeURIComponent(arr[2*ques[nth]-2+qr[Number(q)]])) + end).replaceAll('=', '');
        document.getElementById('card_nb').innerHTML = nth + 1;
    }
}
function absolute(rel) {
    var link = document.createElement("a");
    link.href = rel;
    return (link.protocol + "//" + link.host + link.pathname);
}
function toTitle(str) {
    return str.replace(
        /\w\S*/g,
        function(txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
        }
    );
}
function download() {
    var date = new Date;
    var text = lst[0].replaceAll('"', '') + '\n' + lst[1] + '\n' + lst[2] + '\n' + lst[3].replaceAll(' ', '') + '\n' + lst[4].replaceAll(' ', '') + '\n' + arr.map((x,i,a) => x.replaceAll('\r', '').replaceAll('\n', '')).map(x => encodeURIComponent(x)).join('\n') + '\n' + date.getFullYear() + String(date.getMonth() + 1).padStart(2, '0') + String(date.getDate()).padStart(2, '0') + String(date.getHours()).padStart(2, '0') + String(date.getMinutes()).padStart(2, '0') + String(date.getSeconds()).padStart(2, '0') + '\n' + btoa(title) + '\n' + absolute(atob(file) + (title.includes('&ndash;')?'/../..':'/..')) + 'cards.txt' + '\n' + filename;
    compress(text,toTitle(title.replace('&ndash;', '_').replace('<i>', '').replace('</i>', '').normalize('NFD').replaceAll(/[\u0300-\u036f]/g, '')).replaceAll(' ', '') + '.txt');
}
function _close() {
    document.title = 'Révisions';
    document.getElementById('title').innerHTML = '&nbsp;';
    document.getElementById('flashcard-front').innerHTML = '';
    document.getElementById('incor').disabled = true;
    document.getElementById('corr').disabled = true;
    document.getElementById('flip').disabled = true;
    document.getElementById('up-button').innerHTML = 'upload';
    document.getElementById('up-button').setAttribute('onclick', 'document.getElementById("open").click()');
    document.getElementById('down-button').style.display = 'none';
    document.getElementById('card_nb').innerHTML = '';
    document.getElementById('card_total').innerHTML = '';
}
async function sync() {
    try {
        response = await fetch(syncurl);
    } catch(error) {window.alert('Impossible de rafraîchir le fichier.');}
    if (response.status == 200) {
        const jsCode = await response.text();
        let ls = jsCode.split('\n'); let found = false;
        for (let i = 0; i < (ls.length - 1)/2; ++i) {
            if (ls[2*i + 1] == atob(filename)) {
                if (parseInt(ls[2*i + 2]) > filedate) {
                    window.alert('Une mise à jour est disponible et va être chargée.');
                    document.getElementById('down-button').style.display = 'none';
                    await fill_svg(absolute(ls[0] + ls[2*i + 1]));
                    document.getElementById('down-button').style.display = 'none';
                    document.getElementById('up-button').style.display = 'block';
                    download()
                } else {window.alert('Le fichier est à jour.')}
                found = true;
                break;
            }
        }
        if (!found) {window.alert('Le fichier n\'est pas disponible.')}
    } else {window.alert('Impossible de rafraîchir le fichier.');}
}
