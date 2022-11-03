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
    const path = 'https://rfoxinter.github.io/revisions/pdf/';
    const extension = '\\.pdf';

    var files = [];

    while (sitemap.search(path)!=-1) {
        var idx_start = sitemap.search(path)+42;
        var idx_end = sitemap.search(extension);
        files.push(sitemap.substring(idx_start,idx_end));
        sitemap = sitemap.substring(idx_end+4,sitemap.length);
    }

    const c = document.getElementsByTagName('main')[0];
    const l = files.length;
    
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
            span.setAttribute('class',"material-symbols-rounded");
            span.innerHTML = 'folder_open';
            h1.appendChild(span);
            h1.innerHTML += ' ' + groupname;
            d.appendChild(h1);
            hr = document.createElement('hr');
            c.appendChild(hr)
            c.appendChild(d);
        }
        p = document.createElement('p');
        var a = document.createElement('a');
        a.setAttribute('href',path + f + '.pdf');
        a.innerHTML = filename + '.pdf';
        p.appendChild(a);
        document.getElementsByClassName(groupname)[0].appendChild(p);
    }
    // display_file_number(files,0,c,path);
}

/*function display_file_number(files,i,c,path) {
    var f = files[i];
    var file = new XMLHttpRequest();
    file.open('GET', 'https://rfoxinter.github.io/revisions/input/' + f.substring(f.search('/')+1,f.length).replace(/[0-9]/g, '') + '.txt');
    file.send();
    file.onreadystatechange = function() {
        if (file.readyState === 4) {
            if (file.status === 200) {
                var n = file.responseText;
                n = n.substring(0,n.search('\\n'));
                var filename = '';
                var groupname = '';
                var idx = n.search(' -- ');
                if (idx == -1) {
                    groupname = 'None';
                    filename = n;
                } else {
                    groupname = n.substring(0,idx);
                    filename = n.substring(idx+4,n.length);
                }
                var last = f[f.length-1];
                if (is_numeric(last)){
                    filename += '' + last;
                }
                if (document.getElementsByClassName(groupname).length == 0) {
                    d = document.createElement('div');
                    d.setAttribute('class',groupname);
                    h1 = document.createElement('h1');
                    h1.setAttribute('style','margin-bottom:0;')
                    h1.innerHTML = groupname;
                    d.appendChild(h1);
                    hr = document.createElement('hr');
                    c.appendChild(hr)
                    c.appendChild(d);
                }
                p = document.createElement('p');
                var a = document.createElement('a');
                a.setAttribute('href',path + f + '.pdf');
                a.innerHTML = filename;
                p.appendChild(a);
                document.getElementsByClassName(groupname)[0].appendChild(p);
                if (i!=files.length-1) {
                    display_file_number(files,i+1,c,path)
                }
            }
        }
    }
}*/