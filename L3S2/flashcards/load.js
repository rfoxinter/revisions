function is_numeric(str){
    return /^\d+$/.test(str);
}

function display() {
    var file = new XMLHttpRequest();
    file.open('GET', 'https://rfoxinter.github.io/revisions/sitemap.xml');
    file.send();
    file.onreadystatechange = function() {
        if (file.readyState === 4) {
            if (file.status === 200) {
                display_files(file.responseText);
            }
        }
    }
}

function display_files(sitemap){
    const path = 'https://rfoxinter.github.io/revisions/L3S2/pdf/';
    const extension = '\\.pdf';

    var files = [];

    while (sitemap.search(path)!=-1) {
        var idx_start = sitemap.search(path)+47;
        var idx_end = sitemap.search(extension);
        files.push(sitemap.substring(idx_start,idx_end));
        sitemap = sitemap.substring(idx_end+4,sitemap.length);
    }

    const c = document.getElementsByTagName('main')[0];
    const l = files.length;
    var name = '';
    
    for (var i=0; i<l; ++i) {
        var f = files[i];
        var filename = '';
        var groupname = '';
        var idx = f.search('/');
        if (idx == -1) {
            groupname = 'None';
            filename = f;
        } else {
            groupname = f.substring(0,idx);
            filename = f.substring(idx+1,f.length);
        }
        if (document.getElementsByClassName(groupname).length == 0) {
            d = document.createElement('div');
            d.setAttribute('class',groupname);
            d.setAttribute('style','margin-left: 2rem;');
            h1 = document.createElement('h1');
            h1.setAttribute('style','margin-bottom:0;margin-left: -2rem;')
            span = document.createElement('span');
            span.setAttribute('onclick', 'folder_click(\''+groupname+'\')');
            span.setAttribute('id', groupname+'_icon');
            span.setAttribute('class','material-symbols-rounded folder');
            span.innerHTML = 'folder_open';
            h1.appendChild(span);
            h1.innerHTML += '&nbsp;' + groupname;
            d.appendChild(h1);
            hr = document.createElement('hr');
            c.appendChild(hr)
            c.appendChild(d);
        }
        p = document.createElement('p');
        if (filename.search(/\.[0-9]/g) == f.length-2) {
            name_tmp = filename.substring(0,f.length-2);
            if (name_tmp != name) {
                p.innerHTML = name_tmp + ' ';
                p.setAttribute('id', name_tmp);
                var a = document.createElement('a');
                a.setAttribute('href', '../../flashcards?file=' + btoa('../L3S2/flashcards/' + name_tmp).replaceAll('=', ''));
                span = document.createElement('span');
                span.setAttribute('class','material-symbols-rounded');
                span.innerHTML = 'open_in_new';
                a.appendChild(span);
                p.appendChild(a);
            }
            name = name_tmp;
        } else {
            p.setAttribute('class',groupname+'_elem');
            name = '';
            p.innerHTML = filename + ' ';
            var a = document.createElement('a');
            a.setAttribute('href', '../../flashcards?file=' + btoa('../L3S2/flashcards/' + f).replaceAll('=', ''));
            span = document.createElement('span');
            span.setAttribute('class','material-symbols-rounded');
            span.innerHTML = 'open_in_new';
            a.appendChild(span);
            p.appendChild(a);
        }
        document.getElementsByClassName(groupname)[0].appendChild(p);
    }
}
