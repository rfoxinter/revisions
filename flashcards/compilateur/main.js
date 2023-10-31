// with huffman.js
function close_bit_text(fd) {
    while (fd.buff !== 1) {
        output_bit(fd, false);
    }
    return fd.data;
}

function compress_text(str) {
    const out = open_bit_out('');
    const tr = build_huffman_tree(str);
    const dict = tree_to_dict(tr);
    encode_tree(out, tr);
    output_bit(out, true);
    encode_text(out, dict, str);
    encode_leaf(out, 256);
    return close_bit_text(out);
}

const { PDFDocument } = PDFLib;

function shuffleArray(array) {
    for (let i = 0; i < array.length-1; ++i) {
        const j = Math.floor(Math.random() * (array.length));
        [array[i], array[j]] = [array[j], array[i]];
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

function array_to_string(arr) {
    var str = "[" + arr[0];
    for (let i = 1; i < arr.length; i++) {
        str += ", " + arr[i];
    }
    str += "]";
    return str;
}

function insertAtIndex(str, substring, index) {
    return str.slice(0, index) + substring + str.slice(index);
}

function bl(str) {
    if (str.search('True') !== -1) return true;
    if (str.search('False' !== -1)) return false;
    throw new Error('The value is not a Boolean');
}

function removeSpecialChars(s) {
    s = s.replaceAll(/[ ]/g, '');
    s = s.replaceAll(/[àáâä]/g, 'a');
    s = s.replaceAll(/[èéêë]/g, 'e');
    s = s.replaceAll(/[îï]/g, 'i');
    s = s.replaceAll(/[ôö]/g, 'o');
    s = s.replaceAll(/[ùúûü]/g, 'u');
    s = s.replaceAll(/[ç]/g, 'c');
    s = s.replaceAll(/[ÀÁÂÄ]/g, 'A');
    s = s.replaceAll(/[ÈÉÊË]/g, 'E');
    s = s.replaceAll(/[ÎÏ]/g, 'I');
    s = s.replaceAll(/[ÔÖ]/g, 'O');
    s = s.replaceAll(/[ÙÚÛÜ]/g, 'U');
    s = s.replaceAll(/[Ç]/g, 'C');
    return s;
}

function generateLatex_flash(r, t, ttle) {
    return new Promise(async function(resolve, reject) {
        try {
            const shQuest = bl(r[1]);
            const shQr = bl(r[2]);
            const defs = r[3];
            r = r.slice(4).filter(item => item !== '').map(row => row.split(';;'));
            if (shQr) {
                for (let i = 0; i < r.lenght; ++i) {
                    shuffleArray(r[i]);
                }
            }
            if (shQuest) {
                shuffleArray(r);
            }
            ttle = t.split(' -- ');
            if (ttle.length === 1) {
                ttle = ttle[0];
            } else {
                ttle = ttle[0] + '\\\\\\emph{' + ttle[1] + '}';
            }

            var latexContent = `\\documentclass[14pt,usepdftitle=false,aspectratio=169]{beamer}
\\usepackage{preambule}
\\setbeamercolor{structure}{fg=black}
${defs}
\\hypersetup{pdftitle=${t}}
\\title{${ttle}}
\\author{}
\\date{}
\\begin{document}
\\begin{frame}
\\titlepage
\\end{frame}
`;

            for (let i = 0; i < r.length; i++) {
                if (r[i][0].startsWith('!!fst')) {
                    r[i][0] = r[i][0].replace('!!fst', '');
                } else if (r[i][1].startsWith('!!fst')) {
                    [r[i][0], r[i][1]] = [r[i][1].replace('!!fst', ''), r[i][0]];
                }

                latexContent += `\\slideq{${r[i][0]}}{${i + 1}/${r.length}}\n`;
                latexContent += `\\slider{${r[i][1]}}{${i + 1}/${r.length}}\n`;
            }

            latexContent += '\\end{document}';
        } catch(error) {reject('file');}

        files.push(latexContent);
        try {await compile(latexContent, files);} catch(error) {reject(error);}
        
        resolve();
    });
}

function main_flash(fileContent) {
    return new Promise(async function(resolve, reject) {
        const r = fileContent.split('\n');
        let t, ttle;

        if (r[0].includes('!ttle')) {
            [ttle, t] = r[0].split('!!ttle');
        } else {
            t = r[0];
            ttle = r[0].split('--');
            if (ttle.length === 1) {
            ttle = toTitle(ttle[0]);
            } else {
            ttle = toTitle(ttle[1]);
            }
            ttle = removeSpecialChars(ttle);
        }

        flash_ttle = ttle;

        try {await generateLatex_flash(r, t, ttle);} catch(error) {reject(error);}
        resolve();
    });
}

function generateLatex_html(r, t, ttle) {
    return new Promise(async function(resolve, reject) {
        try {
            const qr = ['Q', 'R'];
            const fst = [];
            const shQuest = bl(r[1]);
            const shQr = bl(r[2]);
            const defs = r[3];
            r = r.slice(4).filter(item => item !== '').map(row => row.split(';;'));

            html_files = new Array(4 * r.length);
            var promise = [];

            const htmlttle = t.split(' -- ').length === 1
                ? t.split(' -- ')[0]
                : t.split(' -- ')[0] + ' &ndash; <i>' + t.split(' -- ')[1] + '</i>';

            for (let i = 0; i < r.length; i++) {
                for (let j = 0; j < 2; j++) {
                    var text = r[i][j].replaceAll(/\\\\\\\\/g, '\\\\').replaceAll(/\\linebreak/g, '\\\\');
                    const fileContent = `\\documentclass[12pt${!r[i][j].includes('tikzpicture') ? ',border=0.5pt' : ''}]{standalone}
\\usepackage{htmlpreambule}
${defs}
\\begin{document}
\\begin{adjustbox}{varwidth=10cm}
\\begin{center}
${text}
\\end{center}
\\end{adjustbox}
\\end{document}`;

                    if (r[i][j].startsWith('!!fst')) {
                        r[i][j] = r[i][j].replace('!!fst', '');
                        fst.push(1);
                    } else if (j === 0) {
                        fst.push(0);
                    }

                    promise.push(compile(fileContent, html_files, 4 * i + 2 * j));

                }
            }

            infoContent = `"${htmlttle}"\n${shQuest ? '1' : '0'}\n${shQr ? '1' : '0'}\n` + array_to_string(r.map((_, i) => {return i + 1;})) + `\n` + array_to_string(fst);
        } catch(error) {reject("file");}

        try {await Promise.all(promise).then(() => {resolve();})} catch(error) {reject(error);}
    });
}

function main_html(fileContent) {
    return new Promise(async function(resolve, reject) {
        const r = fileContent.split('\n');
        let t, ttle;

        if (r[0].includes('!ttle')) {
            [ttle, t] = r[0].split('!!ttle');
        } else {
            t = r[0];
            ttle = r[0].split('--');
            if (ttle.length === 1) {
                ttle = toTitle(ttle[0]);
            } else {
                ttle = toTitle(ttle[1]);
            }
            ttle = removeSpecialChars(ttle);
        }

        html_ttle = ttle;

        try {
            await generateLatex_html(r, t, ttle);
            var html_doc = await PDFDocument.create();
            var docs;
            var page;
            for (let i = 0; i < r.length - 4; i++) {
                docs = await PDFDocument.load(html_files[4 * i + 1]);
                [page] = await html_doc.copyPages(docs, [0]);
                html_doc.addPage(page);
                docs = await PDFDocument.load(html_files[4 * i + 3]);
                [page] = await html_doc.copyPages(docs, [0]);
                html_doc.addPage(page);
            }
            html_pdf = await html_doc.save();
        } catch(error) {reject(error);}
        resolve();
    });
}

function add_file(engine, rooturl, filename) {
    return new Promise(async function(resolve, reject) {
        try {
            response = await fetch(rooturl + filename);
        } catch(error) {reject();}
        if (response.status == 200) {
            const file = await response.text();
            engine.writeMemFSFile(filename.toLowerCase(), file);
            resolve();
        } else {reject();}
    });
}

async function compile(content, list, index = NaN) {
    const engine = new PdfTeXEngine();
    await engine.loadEngine();
    let packages_file = await fetch('https://rfoxinter.github.io/revisions/output/packages.txt');
    var additional_files = (await packages_file.text()).split('\n');
    for (const filename of additional_files) {
        await add_file(engine, "https://rfoxinter.github.io/revisions/output/", filename);
    }
    engine.writeMemFSFile("main.tex", content);
    engine.setEngineMainFile("main.tex");
    r = await engine.compileLaTeX();
    engine.closeWorker()
    if (isNaN(index)) {
        list.push(r.log);
        list.push(r.pdf);
        if (r.pdf == undefined) {
            throw new Error();
        }
    } else {
        list[index] = r.log;
        list[index + 1] = r.pdf;
        if (r.pdf == undefined) {
            throw new Error(index / 2);
        }
    }
}

function downloadBlob(data, fileName, mimeType) {
    var blob, url;
    blob = new Blob([data], {
        type: mimeType
    });
    url = window.URL.createObjectURL(blob);
    downloadURL(url, fileName);
    setTimeout(function() {
        return window.URL.revokeObjectURL(url);
    }, 1000);
};
function downloadURL(data, fileName) {
    var a;
    a = document.createElement('a');
    a.href = data;
    a.download = fileName;
    a.click();
};

var files = []; var flash_ttle; var html_files = []; var html_ttle; var infoContent = ""; var html_pdf;