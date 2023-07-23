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

function read_card(_url, _name) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");

        var getRequest = store.get([_url, _name]);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                return result.content;
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

var title; var sh_quest; var sh_qr; var n; var ques; var fst; var q; var viewed; var nth; var svgcode; var arr; var wrong = []; var qr = [0, 1]; var id;

async function loadFile(src, file) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");

        var getRequest = store.get([src, file]);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                var jsCode = result.content;
                var fl = deflate(jsCode).split('\n');
                title = fl[0];
                sh_quest = parseInt(fl[1]);
                sh_qr = parseInt(fl[2]);
                n = fl[3].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
                fst = fl[4].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
                arr = new Array(2*n.length);
                for (let i = 0; i < 2*n.length; ++i) {
                    arr[i] = decodeURIComponent(fl[5+i]);
                }
                
                if (fl[6+2*n.length] != btoa(title)) {
                    throw new Error('Fichier corrompu')
                }
            
                q = true;
                viewed = false;
                nth = 0;
            
                document.title = title.replace('&ndash;', '-').replace('<i>', '').replace('</i>', '');
                ques = copyArray(n);
            
                if (sh_quest) {shuffleArray(ques);}

                document.getElementById('flip').disabled = false;
                document.getElementById('title').innerHTML = title;
                document.getElementById('flashcard').innerHTML = arr[2*ques[0]-2];
                document.getElementById('card_nb').innerHTML = nth + 1;
                document.getElementById('card_total').innerHTML = '/' + ques.length;
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

async function load(src, file) {
    document.getElementById("downloaded").style.display="none";
    document.getElementById("viewer").style.display="block";
    id = [src, file];
    document.getElementById('incor').disabled = true;
    document.getElementById('corr').disabled = true;
    document.getElementById('flip').disabled = true;
    document.getElementById('title').innerHTML = '&nbsp;';
    document.getElementById('flashcard').innerHTML = '';
    document.getElementById('card_nb').innerHTML = '';
    document.getElementById('card_total').innerHTML = '';
    await loadFile(src, file);
}

function reverse_card() {
    if (q) {
        document.getElementById('flashcard').innerHTML = arr[2*ques[nth]-2+qr[Number(q)]];
        document.getElementById('flip').innerHTML = 'Voir la question';
        q = false;
        viewed = true;
    } else {
        document.getElementById('flashcard').innerHTML = arr[2*ques[nth]-2+qr[Number(q)]];
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
    if (nth + 1 == ques.length) {
        if (!corr) {wrong.push(ques[nth]);}
        nth += 1;
        document.getElementById('flashcard').innerHTML = 'Terminé';
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
            reverse_card()
        } else {
            ques = copyArray(n);
            shuffleArray(ques);
            wrong = [];
            nth = 0;
            q = false;
            viewed = false;
            qr = [0, 1];
            if (sh_qr && !fst[ques[nth]-1]) {shuffleArray(qr);}
            reverse_card()
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
        document.getElementById('card_nb').innerHTML = nth + 1;
    }
}

var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB || window.shimIndexedDB;

var open = indexedDB.open("flcrdsv");

open.onupgradeneeded = function(event) {
    var db = event.target.result;
    var store = db.createObjectStore("flcrd", {keyPath: ["url", "name"]});
};

function save() {
    try {
        var open = indexedDB.open("flcrdsv");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readwrite");
            var store = tx.objectStore("flcrd");

            store.put({url: id[0], name: id[1], content: compress_text((q?1:0) + "\n" + (viewed?1:0) + "\n" + nth + "\n" + ques.join(",") + "\n" + wrong.join(","))});

            tx.oncomplete = function() {
                window.alert("Sauvegarde effectuée.");
                db.close();
            };
        };
    } catch {window.alert("Une erreur est survenue lors de la sauvegarde.");}
}

function loadsv() {
    var open = indexedDB.open("flcrdsv");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");

        var getRequest = store.get(id);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                var code = deflate(result.content).split("\n");
                q = !code[0];
                nth = parseInt(code[2]);
                document.getElementById('card_nb').innerHTML = nth + 1;
                ques = code[3].split(",").map(x => parseInt(x));
                reverse_card();
                viewed = code[1];
                if (!viewed) {
                    document.getElementById('incor').disabled = false;
                    document.getElementById('corr').disabled = false;
                } else {
                    document.getElementById('incor').disabled = true;
                    document.getElementById('corr').disabled = true;
                }
                wrong = code[4].split(",").map(x => parseInt(x));
            } else {
                window.alert("Aucune sauvegarde à charger");
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function displaydd(event){event.target.id === "save" || event.target.classList.contains("option")?document.getElementById("dropdown").style.display="block":document.getElementById("dropdown").style.display="none";}

if (/Mobi|Android/i.test(navigator.userAgent)) {addEventListener("touchstart", (event) => {displaydd(event);});} else {addEventListener("mouseover", (event) => {displaydd(event);});}
 