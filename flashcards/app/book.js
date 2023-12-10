// var fldebug;
async function loadBook(src, file) {
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
                // fldebug = fl;
                title = dec_title(fl[0]);
                n = fl[3].replace(']', '').replace('[', '').split(',').map(x => parseInt(x));
                
                if (fl[6+2*n.length] != btoa(enc_title(title))) {
                    throw new Error('Fichier corrompu')
                }

                let tbl = document.getElementById('book_table');
                tbl.innerHTML = '';
                let start = '<!DOCTYPE html><html style="height: 100%;"><head style="height: 100%;"><meta charset="utf-8"><style>svg {max-width: 100%; max-height: 100% !important;fill: #606c71;width: unset !important;vertical-align: middle; scale: 2.5;}path {stroke: #606c71;}* {-webkit-user-select: none; -ms-user-select: none; user-select: none;}body {margin: 0pt;}</style><script>document.addEventListener("contextmenu", (event) => {event.preventDefault();});</script></head><body style="height: 100%;"><div style="text-align: center; margin-bottom: 0rem; white-space: unset; height: 100%;"><span style="display: flex; align-items: center; justify-content: center; height: 100%;"><div style="height: 40%; max-width: 40%; display: flex; align-items: center;">';
                let end = '</div></span></div></body></html>';
                for (let i = 0; i < 2*n.length; ++i) {
                    tr = document.createElement('tr');
                    td1 = document.createElement('td');
                    ifr1 = document.createElement('iframe');
                    ifr1.setAttribute('style', 'height: 100%');
                    ifr1.src = 'data:text/html;base64,' + btoa(start + unescape(fl[5+i]) + end).replaceAll('=', '');
                    td1.appendChild(ifr1);
                    tr.appendChild(td1);
                    ++i;
                    td2 = document.createElement('td');
                    ifr2 = document.createElement('iframe');
                    ifr2.setAttribute('style', 'height: 100%');
                    ifr2.src = 'data:text/html;base64,' + btoa(start + unescape(fl[5+i]) + end).replaceAll('=', '');
                    td2.appendChild(ifr2);
                    tr.appendChild(td2);
                    tbl.appendChild(tr);
                }

                document.title = title.replace('&ndash;', '-').replace('<i>', '').replace('</i>', '');

                document.getElementById('book_title').innerHTML = title;
            }
        };

        tx.oncomplete = function() {
            db.close();
        };
    };
}

function list_card(src, file) {
    document.getElementById('book_table').innerHTML = '';
    document.getElementById('book_title').innerHTML = '&nbsp;';
    document.getElementById("downloaded").style.display="none";
    document.getElementById("book").style.display="block";
    id = [src, file];
    loadBook(src, file);
}