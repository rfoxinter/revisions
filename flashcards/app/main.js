const icon_state = {'folder':0, 'folder_open':1};
const disp_icon = {0:'folder', 1:'folder_open'};
const text_state = {'none':0, '':1};
const disp_text = {0:'none', 1:''};

function folder_click(groupname) {
    document.getElementById(groupname+'_icon').innerHTML=disp_icon[1-icon_state[document.getElementById(groupname+'_icon').innerHTML]];
    const elem = document.getElementsByClassName(groupname+'_elem');
    const disp = disp_text[1-text_state[elem[0].style.display]];
    for(var i = 0; i < elem.length; ++i) {
        elem[i].style.display = disp;
    }
}

function display_cards() {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");
        var request = store.openCursor();

        request.onsuccess = function(event) {
            var cursor = event.target.result;
            if (cursor) {
                var key = cursor.primaryKey;
                append_card(key[0], key[1]);
                cursor.continue();
            }
        };
    };
}

async function list_cards() {
    let flurl = absolute(document.getElementById("file").value);
    if (flurl.substring(flurl.length - 9) !== "cards.txt") {window.alert("Fichier incorrect");return;}
    try {
        response = await fetch(flurl);
    } catch(error) {window.alert('Impossible de rafraîchir le fichier.');}
    if (response.status == 200) {
        document.getElementById("cards_container").textContent= "";
        const jsCode = await response.text();
        let ls = jsCode.split('\n');
        var open = indexedDB.open("flcrddb");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readonly");
            var store = tx.objectStore("flcrd");

            for (let i = 0; i < (ls.length - 1)/2; ++i) {
                let p = document.createElement("p");
                p.innerText = ls[2*i+1] + "\xa0";
                let a = document.createElement("a");
                let span = document.createElement("span");
                var getRequest = store.get([flurl, ls[2*i+1]]);
                getRequest.onsuccess = function(event) {
                    var result = event.target.result;
                    if (result) {
                        span.innerText = "check_circle";
                        span.style.color = "#159957";
                        a.href = "javascript:void(0)";
                    } else {
                        span.innerText = "download";
                        a.href = "javascript:add_card('"+flurl+"','"+ls[2*i+1]+"','"+absolute(ls[0]+ls[2*i+1])+"',"+i+")";
                    }
                };
                span.className = "material-symbols-rounded";
                span.id = i + "_card";
                a.appendChild(span);
                p.appendChild(a);
                document.getElementById("cards_container").appendChild(p);
            }
            

            tx.oncomplete = function() {
                db.close();
            };
        };
    } else {window.alert('Impossible de rafraîchir le fichier.');}
}

function append_card(src, name) {
    let c = document.getElementById('down_cards_container');
    if (document.getElementsByClassName(src).length == 0) {
        d = document.createElement('div');
        d.setAttribute('class',src);
        d.setAttribute('style','margin-left: 2rem;');
        h1 = document.createElement('h1');
        h1.setAttribute('style','margin-bottom:0;margin-left: -2rem; font-size: calc(0.8 * 2em);')
        span = document.createElement('span');
        span.setAttribute('onclick', 'folder_click(\''+src+'\')');
        span.setAttribute('id', src+'_icon');
        span.setAttribute('class','material-symbols-rounded folder');
        span.innerHTML = 'folder_open';
        h1.appendChild(span);
        h1.innerHTML += ' ' + src;
        d.appendChild(h1);
        if (document.getElementById('down_cards_container').children.length > 0) {
            hr = document.createElement('hr');
            c.appendChild(hr);
        }
        c.appendChild(d);
    }
    p = document.createElement('p');
    p.setAttribute('class',src+'_elem');
    p.innerHTML = name + ' ';
    var a = document.createElement('a');
    a.setAttribute('href', 'viewer.html?src='+btoa(src)+'&file='+btoa(name));
    span = document.createElement('span');
    span.setAttribute('class','material-symbols-rounded');
    span.innerHTML = 'open_in_new';
    a.appendChild(span);
    p.appendChild(a);
    p.innerHTML += ' ';
    var a2 = document.createElement('a');
    a2.setAttribute('href', 'javascript:sync("'+src+'","'+name+'")');
    a2.style.color = "#159957";
    span2 = document.createElement('span');
    span2.setAttribute('class','material-symbols-rounded');
    span2.innerHTML = 'sync';
    a2.appendChild(span2);
    p.appendChild(a2);
    p.innerHTML += ' ';
    var a3 = document.createElement('a');
    a3.setAttribute('href', 'javascript:delete_card("'+src+'","'+name+'")');
    a3.style.color = "#EC7063";
    span3 = document.createElement('span');
    span3.setAttribute('class','material-symbols-rounded');
    span3.innerHTML = 'delete';
    a3.appendChild(span3);
    p.appendChild(a3);
    p.id = '[' + src + ',' + name + ']';
    document.getElementsByClassName(src)[0].appendChild(p);
}

var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB || window.shimIndexedDB;

var open = indexedDB.open("flcrddb");

open.onupgradeneeded = function(event) {
    var db = event.target.result;
    var store = db.createObjectStore("flcrd", {keyPath: ["url", "name"]});
};

function delete_card(_url, _name) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readwrite");
        var store = tx.objectStore("flcrd");

        store.delete([_url, _name]);

        tx.oncomplete = function() {
            db.close();
        };
    };
    document.getElementsByClassName(_url)[0].removeChild(document.getElementById('[' + _url + ',' + _name + ']'));
    if (document.getElementsByClassName(_url)[0].children.length <= 1) {
        document.getElementById('down_cards_container').removeChild(document.getElementsByClassName(_url)[0]);
    }
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

function read_date(_url, _name) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");

        var getRequest = store.get([_url, _name]);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                return parseInt(result.date);
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

async function add_card(_url, _name, filesrc, nb) {
    if (nb !== undefined) {
        let a = document.getElementById(nb + "_card");
        try {
            a.href = "javascript:void(0)";
            a.innerHTML = "downloading";
            a.style.color = "#F5B041";
            var contentdate = await downcrd(filesrc, _name);
            if (contentdate === undefined) {throw new Error("Erreur lors du téléchargement")}
            a.innerHTML = "check_circle";
            a.style.color = "#159957";
            var open = indexedDB.open("flcrddb");
            open.onsuccess = function(event) {
                var db = event.target.result;
                var tx = db.transaction("flcrd", "readwrite");
                var store = tx.objectStore("flcrd");
        
                store.put({url: _url, name: _name, content: contentdate[0], date: contentdate[1]});
        
                tx.oncomplete = function() {
                    db.close();
                };
            };
            append_card(_url, _name);
        } catch {
            a.innerHTML = "error";
            a.style.color = "#EC7063";
            a.href = "javascript:add_card('" + _url + "', '" + _name + "', '" + filesrc + "', " + nb + ")";
        }
    } else {
        var contentdate = await downcrd(filesrc, _name);
        if (contentdate === undefined) {throw new Error("Erreur lors du téléchargement")}
        var open = indexedDB.open("flcrddb");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readwrite");
            var store = tx.objectStore("flcrd");

            store.put({url: _url, name: _name, content: contentdate[0], date: contentdate[1]});

            tx.oncomplete = function() {
                db.close();
            };
        };
    }
}

function read_all() {
    var contents = [];
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");
        var request = store.openCursor();

        request.onsuccess = function(event) {
            var cursor = event.target.result;
            if (cursor) {
                var key = cursor.primaryKey;
                contents.push([key[0], key[1]]);
                cursor.continue();
            }
        };
    };
    return contents;
}

function refresh() {
    var c = document.getElementById('down_cards_container');
    for (let i = 0; i<c.children.length; ++i) {
        c.removeChild(c.children[i]);
    }
    display_cards();
}