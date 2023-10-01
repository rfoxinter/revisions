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

var title; var sh_quest; var sh_qr; var n; var ques; var fst; var q; var viewed; var nth; var arr; var wrong = []; var qr = [0, 1]; var id;

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

                qr = [0, 1]
                wrong = []
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

function load(src, file) {
    document.getElementById('incor').innerText = 'Réponse incorrecte';
    document.getElementById('corr').innerText = 'Réponse correcte';
    document.getElementById('flip').innerHTML = 'Voir la réponse';
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
    loadFile(src, file);
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
    var open = indexedDB.open("flcrdsv");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readwrite");
        var store = tx.objectStore("flcrd");

        try {
            store.put({url: id[0], name: id[1], content: compress_text((q?1:0) + "\n" + (viewed?1:0) + "\n" + nth + "\n" + ques.join(",") + "\n" + wrong.join(",") + "\n" + id.map(x => btoa(x)).join(','))});
            document.getElementById("dropdown").style.display="none";
            document.getElementById("adv_dropdown").style.display = "none";
            window.alert("Sauvegarde effectuée");
        } catch {window.alert("Une erreur est survenue lors de la sauvegarde");}

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function load_sv_content(content) {
    var code = deflate(content).split("\n");
    if (code.length > 5 && code[5] !== id.map(x => btoa(x)).join(',')) {
        window.alert("Sauvegarde corrompue");
        return;
    }
    q = !code[0];
    nth = parseInt(code[2]);
    ques = code[3].split(",").map(x => parseInt(x));
    viewed = code[1];
    wrong = code[4] === ""?[]:code[4].split(",").map(x => parseInt(x));
    if (nth === ques.length) {
        nth -= 1;
        new_card(true);
    } else {
        document.getElementById('card_total').innerHTML = '/' + ques.length;
        document.getElementById('card_nb').innerHTML = nth + 1;
        reverse_card();
        viewed = code[1];
        if (!viewed) {
            document.getElementById('incor').disabled = false;
            document.getElementById('corr').disabled = false;
        } else {
            document.getElementById('incor').disabled = true;
            document.getElementById('corr').disabled = true;
        }
        
    }
    document.getElementById("dropdown").style.display="none";
    document.getElementById("adv_dropdown").style.display = "none";
    window.alert("Sauvegarde chargée");
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
                load_sv_content(result.content);
            } else {
                document.getElementById("dropdown").style.display="none";
                document.getElementById("adv_dropdown").style.display = "none";
                window.alert("Aucune sauvegarde à charger");
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function delsv() {
    if (window.confirm("Supprimer la sauvegarde")) {
        var open = indexedDB.open("flcrdsv");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readwrite");
            var store = tx.objectStore("flcrd");

            var getRequest = store.get(id);

            getRequest.onsuccess = function(event) {
                var result = event.target.result;
                if (result) {
                    store.delete(id);
                    document.getElementById("dropdown").style.display="none";
                    document.getElementById("adv_dropdown").style.display = "none";
                    window.alert("Sauvegarde supprimée")
                } else {
                    document.getElementById("dropdown").style.display="none";
                    document.getElementById("adv_dropdown").style.display = "none";
                    window.alert("Aucune sauvegarde à supprimer");
                }
            }

            tx.oncomplete = function() {
                db.close();
            };
        };
    }
}

function toTitle(str) {
    return str.replace(
        /\w\S*/g,
        function(txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
        }
    );
}

function expsv() {
    var open = indexedDB.open("flcrdsv");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");

        var getRequest = store.get(id);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                const data = new Blob([result.content], { type: 'application/octet-stream' });
                const url = URL.createObjectURL(data);

                const downloadLink = document.createElement('a');
                downloadLink.href = url;
                downloadLink.download = toTitle(title.replace('&ndash;', '_').replace('<i>', '').replace('</i>', '').normalize('NFD').replaceAll(/[\u0300-\u036f]/g, '')).replaceAll(' ', '') + '_Progression.txt';
                downloadLink.style.display = 'none';
                document.body.appendChild(downloadLink);

                downloadLink.click();

                // Clean up
                document.body.removeChild(downloadLink);
                URL.revokeObjectURL(url);
            } else {
                window.alert("Aucune sauvegarde à exporter");
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

async function upsv() {
    var response;
    try {
        var url = prompt("URL de la sauvegarde");
        if (url !== "" && url !== null) {
            response = await fetch(url);
            if (response.status == 200) {
                load_sv_content(await response.text());
            } else {
                window.alert("Impossible de charger la sauvegarde");
            }
        }
        document.getElementById("dropdown_up").style.display = "none";
    } catch {
        window.alert("Impossible de charger la sauvegarde");
    }
}

document.addEventListener("contextmenu", (event) => {
    event.preventDefault();
    if (event.target.id === "save") {
        document.getElementById("adv_dropdown").style.display = "block";
    }
});
 
