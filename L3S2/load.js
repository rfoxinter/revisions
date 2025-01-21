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
            h1.innerHTML += ' ' + groupname;
            d.appendChild(h1);
            hr = document.createElement('hr');
            c.appendChild(hr)
            c.appendChild(d);
        }
        p = document.createElement('p');
        if (filename.search(/\.[0-9]/g) == f.length-2) {
            name_tmp = filename.substring(0,f.length-2);
            if (name_tmp != name) {
                p.innerHTML = name_tmp + '.pdf ';
                p.setAttribute('id', name_tmp);
                p.innerHTML += '  ' + f.substring(f.length-1, f.length) + ' ';
                var a = document.createElement('a');
                a.setAttribute('href', 'https://mozilla.github.io/pdf.js/web/viewer.html?file=' + path + f + '.pdf');
                a.setAttribute('target', '_blank');
                span = document.createElement('span');
                span.setAttribute('class','material-symbols-rounded');
                span.innerHTML = 'open_in_new';
                a.appendChild(span);
                p.appendChild(a);
                p.innerHTML += ' ';
                var a2 = document.createElement('a');
                a2.setAttribute('href', f + '.pdf');
                span2 = document.createElement('span');
                span2.setAttribute('class','material-symbols-rounded');
                span2.innerHTML = 'download';
                a2.appendChild(span2);
                a2.setAttribute('download', 'pdf/' + filename + '.pdf');
                p.appendChild(a2);
            } else {
                p = document.getElementById(name_tmp);
                p.innerHTML += '  ' + f.substring(f.length-1, f.length) + ' ';
                var a = document.createElement('a');
                a.setAttribute('href', 'https://mozilla.github.io/pdf.js/web/viewer.html?file=' + path + f + '.pdf');
                a.setAttribute('target', '_blank');
                span = document.createElement('span');
                span.setAttribute('class','material-symbols-rounded');
                span.innerHTML = 'open_in_new';
                a.appendChild(span);
                p.appendChild(a);
                p.innerHTML += ' ';
                var a2 = document.createElement('a');
                a2.setAttribute('href', 'pdf/' + f + '.pdf');
                span2 = document.createElement('span');
                span2.setAttribute('class','material-symbols-rounded');
                span2.innerHTML = 'download';
                a2.appendChild(span2);
                a2.setAttribute('download', filename + '.pdf');
                p.appendChild(a2);

            }
            
            name = name_tmp;
        } else {
            p.setAttribute('class',groupname+'_elem');
            name = '';
            p.innerHTML = filename + '.pdf ';
            var a = document.createElement('a');
            a.setAttribute('href', 'https://mozilla.github.io/pdf.js/web/viewer.html?file=' + path + f + '.pdf');
            a.setAttribute('target', '_blank');
            span = document.createElement('span');
            span.setAttribute('class','material-symbols-rounded');
            span.innerHTML = 'open_in_new';
            a.appendChild(span);
            p.appendChild(a);
            p.innerHTML += ' ';
            var a2 = document.createElement('a');
            a2.setAttribute('href', 'pdf/' + f + '.pdf');
            span2 = document.createElement('span');
            span2.setAttribute('class','material-symbols-rounded');
            span2.innerHTML = 'download';
            a2.appendChild(span2);
            a2.setAttribute('download', filename + '.pdf');
            p.appendChild(a2);
        }
        document.getElementsByClassName(groupname)[0].appendChild(p);
    }
}
