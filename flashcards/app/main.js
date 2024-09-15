const icon_state = {'folder':0, 'folder_open':1};
const disp_icon = {0:'folder', 1:'folder_open'};
const text_state = {'none':0, 'block':1};
const disp_text = {0:'none', 1:'block'};

function folder_click(groupname) {
    document.getElementById(groupname+'_icon').innerHTML=disp_icon[1-icon_state[document.getElementById(groupname+'_icon').innerHTML]];
    const elem = document.getElementsByClassName(groupname+'_elem');
    const disp = disp_text[1-text_state[window.getComputedStyle(elem[0], null).display]];
    replace_css_rule(groupname + "_elem", disp);
}

function replace_css_rule(edit_class, visibility) {
    var styleTag = document.getElementById("folders_display_style");
    var content = styleTag.innerHTML.split("\n");
    var css_selector = edit_class.replaceAll("/", "\\/").replaceAll(":", "\\:").replaceAll(".", "\\.").replaceAll("_", "\\_");

    var modified = false;
    for (var i=0; i<content.length; i++) {
        if (content[i].search('.' + css_selector.replaceAll("\\", "\\\\")) !== -1) {
            content[i] = "." + css_selector + "{display:" + visibility + "};";
            styleTag.innerHTML = content.join("\n");
            modified = true;
            break;
        }
    }

    if (!modified) {styleTag.innerHTML += "." + css_selector + "{display:" + visibility + "};\n";}
}

var card_nb = 0;
var first_of_folder = new Map();
function display_cards() {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");
        var request = store.openCursor();

        request.onsuccess = function(event) {
            var cursor = event.target.result;
            var prev_url = "";
            if (cursor) {
                var key = cursor.primaryKey;
                var card_name = cursor.value.card_name;
                ++ card_nb;
                let title = card_name.split(" &ndash; ");
                if (title.length == 1) {
                    var folder = "root";
                } else {
                    var folder = title[0].replaceAll(" ", "_");
                }
                let val = first_of_folder.get((key[0], folder));
                if (val === undefined) {
                    first_of_folder.set((key[0], folder), card_nb);
                }
                append_card(key[0], key[1], card_nb, card_name, prev_url != key[0]);
                prev_url = key[0];
                cursor.continue();
            }
        }

        tx.oncomplete = function() {
            db.close();
        }
    };
}

async function list_cards(downloaded = false) {
    let flurl = absolute(document.getElementById("file").value);
    document.getElementById("cards_container").textContent= "";
    if (downloaded) {
        let p = document.createElement("p");
        let a = document.createElement("a");
        a.innerText = "Configurer la source";
        a.href = "javascript:config_src('" + flurl + "')";
        p.appendChild(a);
        document.getElementById("cards_container").appendChild(p);
    }
    if (flurl.substring(flurl.length - 9) !== "cards.txt") {window.alert("Fichier incorrect"); return;}
    try {
        response = await fetch(flurl);
    } catch(error) {window.alert("Impossible de charger les fiches");}
    if (response.status == 200) {
        const jsCode = await response.text();
        let ls = jsCode.split('\n');
        var open = indexedDB.open("flcrddb");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readonly");
            var store = tx.objectStore("flcrd");

            
            let p = document.createElement("p");
            let a = document.createElement("a");
            a.innerText = "Tout télécharger";
            a.href = "javascript:add_all(" + downloaded + ")";
            p.appendChild(a);
            document.getElementById("cards_container").appendChild(p);

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

async function append_card(src, name, card_number, card_name, edit_visibility) {
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
        h1.innerHTML += '\xa0';
        span2 = document.createElement('span');
        if (src !== "Fichiers importés") {
            span2.setAttribute('onclick', 'document.getElementById("downloaded").style.display = "none"; document.getElementById("download").style.display = "block"; document.getElementById("file").value = "' + src + '"; list_cards(true);');
            span2.style.cursor = 'pointer';
        }
        span2.setAttribute('id', src+'_text');
        span2.style.fontSize = 'inherit';
        span2.innerHTML = src;
        h1.appendChild(span2);
        d.appendChild(h1);
        let rootdiv = document.createElement("div");
        rootdiv.classList.add("["+src+",root]");
        d.appendChild(rootdiv);
        if (src == "Fichiers importés") {
            if (document.getElementById('down_cards_container').children.length > 0) {
                hr = document.createElement('hr');
                c.prepend(hr);
            }
            c.prepend(d);
        } else {
            if (document.getElementById('down_cards_container').children.length > 0) {
                hr = document.createElement('hr');
                c.appendChild(hr);
            }
            c.appendChild(d);
        }
        set_config_title(src);
    }
    p = document.createElement('p');
    p.setAttribute('class',src+'_elem');
    span = document.createElement('span');
    span.innerHTML = name;
    p.appendChild(span);
    p.innerHTML += ' ';
    var a = document.createElement('a');
    a.setAttribute('href', 'javascript:load("'+src+'","'+name+'")');
    span = document.createElement('span');
    span.setAttribute('class','material-symbols-rounded');
    span.innerHTML = 'open_in_new';
    a.appendChild(span);
    p.appendChild(a);
    p.innerHTML += ' ';
    var a4 = document.createElement('a');
    a4.setAttribute('href', 'javascript:list_card("'+src+'","'+name+'")');
    a4.style.color = "#E29112";
    span4 = document.createElement('span');
    span4.setAttribute('class','material-symbols-rounded');
    span4.innerHTML = 'menu_book';
    a4.appendChild(span4);
    p.appendChild(a4);
    p.innerHTML += ' ';
    var a2 = document.createElement('a');
    if (src !== "Fichiers importés") {
        a2.setAttribute('href', 'javascript:sync("'+src+'","'+name+'")')
    } else {
        a2.setAttribute('href', 'javascript:sync_upload("'+name+'")')
    }
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
    set_config_card(src, name, card_number, card_name, edit_visibility);
}

var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB || window.shimIndexedDB;

var open = indexedDB.open("flcrddb");

open.onupgradeneeded = function(event) {
    var db = event.target.result;
    var store = db.createObjectStore("flcrd", {keyPath: ["url", "name"]});
    var store2 = db.createObjectStore("flcfg", {keyPath: "url"});
};

function delete_card(_url, _name, _confirm = true) {
    return new Promise(function(resolve, reject) {
        if ((!_confirm) || window.confirm("Supprimer la fiche")) {
            delsv(false);
            var open = indexedDB.open("flcrddb");
            open.onsuccess = function(event) {
                var db = event.target.result;
                var tx = db.transaction("flcrd", "readwrite");
                var store = tx.objectStore("flcrd");

                store.delete([_url, _name]);

                tx.oncomplete = function() {
                    resolve();
                    db.close();
                };
            };
            if (_confirm) {
                document.getElementsByClassName(_url)[0].removeChild(document.getElementById('[' + _url + ',' + _name + ']'));
                if (document.getElementsByClassName(_url)[0].children.length <= 1) {
                    document.getElementById('down_cards_container').removeChild(document.getElementsByClassName(_url)[0]);
                }
            }
        }
    });
}

function read_card(_url, _name) {
    return new Promise(function(resolve, reject) {
        var open = indexedDB.open("flcrddb");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readonly");
            var store = tx.objectStore("flcrd");

            var getRequest = store.get([_url, _name]);

            getRequest.onsuccess = function(event) {
                var result = event.target.result;
                if (result) {
                    resolve(result.content);
                } else {
                    reject();
                }
            };

            tx.oncomplete = function() {
                db.close();
            };
        };
    });
}

function read_date(_url, _name) {
    return new Promise(function(resolve, reject) {
        var open = indexedDB.open("flcrddb");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readonly");
            var store = tx.objectStore("flcrd");

            var getRequest = store.get([_url, _name]);

            getRequest.onsuccess = function(event) {
                var result = event.target.result;
                if (result) {
                    resolve(parseInt(result.date));
                } else {
                    reject("Pas trouvé");
                }
            };

            tx.oncomplete = function() {
                db.close();
            };
        };
    });
}

function read_upd(_url) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcrd", "readonly");
        var store = tx.objectStore("flcrd");

        var getRequest = store.get(_url);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                return result.auto_upd;
            } else {
                return false;
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function read_name(_url, _name) {
    return new Promise(function(resolve, reject) {
        var open = indexedDB.open("flcrddb");
        open.onsuccess = function(event) {
            var db = event.target.result;
            var tx = db.transaction("flcrd", "readonly");
            var store = tx.objectStore("flcrd");

            var getRequest = store.get([_url, _name]);

            getRequest.onsuccess = function(event) {
                var result = event.target.result;
                if (result) {
                    resolve(result.card_name);
                } else {
                    reject("Pas trouvé");
                }
            };

            tx.oncomplete = function() {
                db.close();
            };
        };
    });
}

function add_card(_url, _name, filesrc, nb) {
    return new Promise(async function(resolve, reject) {
        if (nb !== undefined) {
            let a = document.getElementById(nb + "_card");
            try {
                a.parentElement.href = "javascript:void(0)";
                a.innerHTML = "downloading";
                a.style.color = "#E29112";
                var contentdate = await downcrd(filesrc, _name);
                if (contentdate === undefined) {throw new Error("Erreur lors du téléchargement");}
                a.innerHTML = "check_circle";
                a.style.color = "#159957";
                var open = indexedDB.open("flcrddb");
                open.onsuccess = function(event) {
                    var db = event.target.result;
                    var tx = db.transaction("flcrd", "readwrite");
                    var store = tx.objectStore("flcrd");
            
                    store.put({url: _url, name: _name, content: contentdate[0], date: contentdate[1], card_name: contentdate[2]});
            
                    tx.oncomplete = function() {
                        resolve();
                        db.close();
                    };
                };
                append_card(_url, _name, card_nb);
                ++ card_nb;
            } catch {
                reject();
                a.innerHTML = "error";
                a.style.color = "#EC7063";
                a.parentElement.href = "javascript:add_card('" + _url + "', '" + _name + "', '" + filesrc + "', " + nb + ")";
            }
        } else {
            var contentdate = await downcrd(filesrc, _name);
            if (contentdate === undefined) {throw new Error("Erreur lors du téléchargement")}
            var open = indexedDB.open("flcrddb");
            open.onsuccess = function(event) {
                var db = event.target.result;
                var tx = db.transaction("flcrd", "readwrite");
                var store = tx.objectStore("flcrd");

                store.put({url: _url, name: _name, content: contentdate[0], date: contentdate[1], card_name: contentdate[2]});

                tx.oncomplete = function() {
                    resolve();
                    db.close();
                };
            };
        }
    });
}

function add_all(downloaded) {
    var elems = document.getElementById("cards_container").childNodes;
    for (i = 1 + downloaded; i < elems.length; ++i) {
        elems[i].getElementsByTagName("span")[0].click();
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
    var l = c.children.length;
    for (let i = 0; i < l; ++i) {
        c.removeChild(c.children[0]);
        if (i === l - 1) {display_cards();}
    }
}

function add_config(_url, _alias, _orig_name, _root, closed, auto_upd, group_folder) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcfg", "readwrite");
        var store = tx.objectStore("flcfg");

        store.put({url: _url, alias: _alias, orig_name: _orig_name, root: _root, close: closed, auto_upd: auto_upd, group_folder: group_folder});

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function set_config_title(_url) {
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcfg", "readonly");
        var store = tx.objectStore("flcfg");

        var getRequest = store.get(_url);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                document.getElementById(_url + '_text').innerHTML = result.alias;
                if (result.close) {
                    folder_click(_url);
                }
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

let _url_orig_name_close = new Map();
function get_orig_name_close(_url) {
    return new Promise(function(resolve, reject) {
        let dict_val = _url_orig_name_close.get(_url);
        if (dict_val !== undefined) {
            resolve(dict_val);
        } else {
            var open = indexedDB.open("flcrddb");
            open.onsuccess = function(event) {
                var db = event.target.result;
                var tx = db.transaction("flcfg", "readonly");
                var store = tx.objectStore("flcfg");
    
                var getRequest = store.get(_url);
    
                getRequest.onsuccess = function(event) {
                    var result = event.target.result;
                    if (result) {
                        _url_orig_name_close.set(_url, [result.orig_name,result.close,result.group_folder,result.root]);
                        resolve([result.orig_name,result.close,result.group_folder,result.root]);
                    } else {
                        reject("Pas trouvé");
                    }
                };
    
                tx.oncomplete = function() {
                    db.close();
                };
            };
        }
    });
}

async function set_config_card(_url, _name, card_number, card_name) {
    let [orig_name, close, group_folder, root] = await get_orig_name_close(_url);
    try {
        if (orig_name) {
            document.getElementById('[' + _url + ',' + _name + ']').getElementsByTagName('span')[0].innerHTML = card_name;
        } else {
            document.getElementById('[' + _url + ',' + _name + ']').getElementsByTagName('span')[0].innerHTML = document.getElementById('[' + _url + ',' + _name + ']').getElementsByTagName('span')[0].innerHTML.replace(root, '');
        }
        replace_css_rule(_url + "_elem", close?"none":"block");
        if (group_folder) {
            group_per_folder(_url, _name, card_name, close, card_number);
        }
    } catch {}
}

Element.prototype.insertChildAtIndex = function(child, index) {
    if (!index) {index = 0};
    if (index >= this.children.length) {
        this.appendChild(child);
    } else {
        this.insertBefore(child, this.children[index]);
    }
}
function group_per_folder(_url, _name, name, close, card_number) {
    let urldiv = document.getElementsByClassName(_url)[0];
    let title = name.split(" &ndash; ");
    if (title.length == 1) {
        var folder = "root";
        var card_name = title[0];
    } else {
        var folder_name = title[0];
        var folder = title[0].replaceAll(" ", "_");
        var card_name = title[1].replace("<i>","").replace("</i>","");
    }
    var first_number = first_of_folder.get((_url, folder));
    if (document.getElementsByClassName("["+_url+","+folder+"]").length === 0) {
        let div = document.createElement("div");
        div.classList.add("["+_url+","+folder+"]");
        div.classList.add(_url+"_elem");
        div.setAttribute('style','margin-left: 1.5rem;');
        h2 = document.createElement('h2');
        h2.setAttribute('style','margin-bottom:0;margin-left: -1.5rem; font-size: calc(0.8 * 1.5em);')
        span = document.createElement('span');
        span.setAttribute('class','material-symbols-rounded folder');
        span.innerHTML = 'folder_open';
        h2.appendChild(span);
        h2.innerHTML += '\xa0';
        span2 = document.createElement('span');
        span2.style.fontSize = 'inherit';
        span2.innerHTML = folder_name;
        h2.appendChild(span2);
        div.appendChild(h2);
        document.getElementsByClassName(_url)[0].appendChild(div);
    }
    let elt = document.getElementById('[' + _url + ',' + _name + ']');
    urldiv.removeChild(elt);
    document.getElementsByClassName("["+_url+","+folder+"]")[0].insertChildAtIndex(elt, Math.max(card_number - first_number, 0) + 1);
    elt.children[0].innerHTML = card_name;
    if (folder != "root") {
        elt.classList.toggle(_url + "_elem");
        elt.style.display = "block";
    }
}

function config_src(src) {
    document.getElementById('download').style.display = 'none';
    document.getElementById('config').style.display = 'block';
    document.getElementById('cfgsrc').innerHTML = src;
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcfg", "readonly");
        var store = tx.objectStore("flcfg");

        var getRequest = store.get(src);

        getRequest.onsuccess = function(event) {
            var result = event.target.result;
            if (result) {
                document.getElementById("alias").value = result.alias;
                document.getElementById("fl_name").checked = result.orig_name;
                ch_clicked();
                document.getElementById("fl_closed").checked = result.close;
                document.getElementById("auto_upd").checked = result.auto_upd;
                document.getElementById("root").value = result.root;
                document.getElementById("group_folder").checked = result.group_folder;
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function set_config() {
    let src = document.getElementById('cfgsrc').innerHTML;
    var open = indexedDB.open("flcrddb");
    open.onsuccess = function(event) {
        var db = event.target.result;
        var tx = db.transaction("flcfg", "readwrite");
        var store = tx.objectStore("flcfg");

        var getRequest = store.get(src);

        getRequest.onsuccess = async function(event) {
            var result = event.target.result;
            if (result) {
                await store.delete(src);
            }
            add_config(src, document.getElementById("alias").value==""?src:document.getElementById("alias").value, document.getElementById("fl_name").checked, document.getElementById("root").value, document.getElementById("fl_closed").checked, document.getElementById("auto_upd").checked, document.getElementById("group_folder").checked);
            _url_orig_name_close.clear();
            window.alert("Configuration appliquée");
            document.getElementById('download').style.display = 'block';
            document.getElementById('config').style.display = 'none';
        };

        tx.oncomplete = function() {
            db.close();
            refresh();
        };
    };
}

function displaydd_up(event) {
    if (event.target.id === "upload" || event.target.classList.contains("option")) {
        document.getElementById("dropdown_up").style.display="block"
    } else if (event.target.id === "save" || event.target.classList.contains("option")) {
        document.getElementById("dropdown").style.display="block"
    } else {
        document.getElementById("dropdown").style.display="none";
        document.getElementById("adv_dropdown").style.display = "none";
        document.getElementById("dropdown_up").style.display="none";
    }
}

async function loadfl() {
    var response;
    try {
        var url = prompt("URL de la fiche");
        if (url !== "" && url !== null) {
            response = await fetch(url);
            if (response.status == 200) {
                var text = await response.text();
                var fl_defl = deflate(text).split("\n");
                if (fl_defl[fl_defl[3].replace(']"', '').replace('"[', '').split(',').map(x => parseInt(x)).length * 2 + 6] !== btoa(fl_defl[0])) {
                    console.log(fl_defl);
                    throw new Error("Fichier corrompu");
                } else {
                    var open = indexedDB.open("flcrddb");
                    open.onsuccess = function(event) {
                        var db = event.target.result;
                        var tx = db.transaction("flcrd", "readwrite");
                        var store = tx.objectStore("flcrd");
                        
                        var getRequest = store.get(["Fichiers importés", fl_defl[0]]);
                        getRequest.onsuccess = function(event) {
                            var result = event.target.result;
                            if (result) {
                                if (window.confirm("Une fiche avec ce nom a déjà été importée. Souhaitez-vous la remplacer ?")) {
                                    store.put({url: "Fichiers importés", name: fl_defl[0], content: fl.result});
                                    window.alert("Fichier importé");
                                }
                            }
                            else {
                                store.put({url: "Fichiers importés", name: fl_defl[0], content: text});
                                ++ card_nb;
                                append_card("Fichiers importés", fl_defl[0], card_nb);
                                window.alert("Fichier importé");
                            }
                        };

                        tx.oncomplete = function() {
                            db.close();
                        };
                    };
                }
            } else {
                window.alert("Impossible de charger la fiche");
            }
        }
        document.getElementById("dropdown").style.display = "none";
        document.getElementById("adv_dropdown").style.display = "none";
    } catch {
        window.alert("Impossible de charger la fiche");
    }
}

function ch_clicked() {
    document.getElementById("root").disabled = document.getElementById("fl_name").checked;
}

if (/Mobi|Android/i.test(navigator.userAgent)) {document.addEventListener("touchstart", (event) => {displaydd_up(event);});} else {document.addEventListener("mouseover", (event) => {displaydd_up(event);});}

document.addEventListener("contextmenu", (event) => {
    if (document.elementFromPoint(event.clientX, event.clientY).tagName != "INPUT") {
        event.preventDefault();
        if (event.target.getAttribute("onclick") === "refresh()") {
            window.location.href = "./delete_sw_cache.html";
        }
        if (event.target.id === "save") {
            document.getElementById("adv_dropdown").style.display = "block";
        }
    }
});
