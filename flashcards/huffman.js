// Types for binary files
class OutBitFile {
    constructor() {
        this.data = '';
        this.buff = 1;
    }

    writeData() {
        localStorage.setItem(finename, this.data);
        this.data = '';
    }
}

class InBitFile {
    constructor(str) {
        this.data = str;
        this.pos = 0;
    }
}

// Functions for files
function open_bit_out(filename) {
    return new OutBitFile(filename);
}

function output_bit(fd, b) {
    fd.buff = fd.buff * 2 + (b ? 1 : 0);
    if (fd.buff >= 64) {
        fd.data += String.fromCharCode(fd.buff - 32);
        fd.buff = 1;
    }
}

function close_bit_out(fd, filename) {
    while (fd.buff !== 1) {
        output_bit(fd, false);
    }
    const data = new Blob([fd.data], { type: 'application/octet-stream' });
    const url = URL.createObjectURL(data);

    const downloadLink = document.createElement('a');
    downloadLink.href = url;
    downloadLink.download = filename;
    downloadLink.style.display = 'none';
    document.body.appendChild(downloadLink);

    downloadLink.click();

    // Clean up
    document.body.removeChild(downloadLink);
    URL.revokeObjectURL(url);
}


// Functions for reading
function read_bit(fd) {
    const i = Math.floor(fd.pos / 6);
    const k = fd.data.charCodeAt(i) - 32;
    const b = (k & (1 << (5 - (fd.pos % 6)))) !== 0;
    ++fd.pos;
    return b;
}

// Function to read the content of a text file
function read_file(filename) {
    const data = fs.readFileSync(filename, 'utf8');
    const lines = data.split('\n').reverse();
    return lines.join('\n');
}

class Leaf {
    constructor(chr, n) {
        this.chr = chr;
        this.n = n;
    }
}

class Node {
    constructor(n, t1, t2) {
        this.n = n;
        this.t1 = t1;
        this.t2 = t2;
    }
}

function char_count(str) {
    const res = new Array(256).fill(0);
    for (let i = 0; i < str.length; i++) {
        const c = str.charCodeAt(i);
        res[c] += 1;
    }
    return res;
}

function nb_codes(tree) {
    if (tree instanceof Leaf) {
        return tree.n;
    } else if (tree instanceof Node) {
        return tree.n;
    }
}

function to_list(arr) {
    let i = 0;
    const lst = [new Leaf(256, 1)];
    for (let n of arr) {
        if (n === 0) {
            i += 1;
        } else {
            lst.push(new Leaf(i, n));
            i += 1;
        }
    }
    return lst;
}

function smallest(lst) {
    if (lst.length === 0) {
        throw new Error("Empty");
    }
    let t1 = lst[0];
    let newLst = [];
    for (let i = 1; i < lst.length; i++) {
        const t2 = lst[i];
        if (nb_codes(t1) < nb_codes(t2)) {
            newLst.push(t2);
        } else {
            newLst.push(t1);
            t1 = t2;
        }
    }
    return [t1, newLst];
}

function build_huffman_tree(str) {
    function aux(lst) {
        if (lst.length === 0) {
            throw new Error("Empty");
        } else if (lst.length === 1) {
            return lst[0];
        } else {
            const [t1, fin1] = smallest(lst);
            const [t2, fin2] = smallest(fin1);
            return aux([new Node(nb_codes(t1) + nb_codes(t2), t1, t2), ...fin2]);
        }
    }
    const charCount = char_count(str);
    const charCountArray = charCount.map((n) => n);
    return aux(to_list(charCountArray));
}

function tree_to_dict(tr) {
    const dict = new Map();
    function aux(path, node) {
        if (node instanceof Leaf) {
            dict.set(node.chr, path);
        } else if (node instanceof Node) {
            aux([...path, false], node.t1);
            aux([...path, true], node.t2);
        }
    }
    aux([], tr);
    return dict;
}

function encode_char(out, dict, chr) {
    const bits = dict.get(chr);
    for (const bit of bits) {
        output_bit(out, bit);
    }
}

function encode_text(out, dict, str) {
    for (let i = 0; i < str.length; i++) {
        const c = str.charCodeAt(i);
        encode_char(out, dict, c);
    }
    encode_char(out, dict, 256);
}

function encode_leaf(out, chr) {
    let x = chr;
    for (let i = 0; i < 9; i++) {
        const bit = x >= (1 << (8 - i)) ? 1 : 0;
        output_bit(out, bit === 1);
        if (bit === 1) {
            x -= 1 << (8 - i);
        }
    }
}

function encode_tree(out, tree) {
    if (tree instanceof Leaf) {
        output_bit(out, false);
        encode_leaf(out, tree.chr);
    } else if (tree instanceof Node) {
        encode_tree(out, tree.t1);
        encode_tree(out, tree.t2);
        output_bit(out, true);
    }
}

function compress(str, filenm) {
    const out = open_bit_out(filenm);
    const tr = build_huffman_tree(str);
    const dict = tree_to_dict(tr);
    encode_tree(out, tr);
    output_bit(out, true);
    encode_text(out, dict, str);
    encode_leaf(out, 256);
    close_bit_out(out, filenm);
}

function decode_tree(infl) {
    function aux(fb, stack) {
        if (fb && stack.length === 1) {
            return stack[0];
        } else if (fb && stack.length > 1) {
            const h1 = stack.shift();
            const h2 = stack.shift();
            return aux(read_bit(infl), [new Node(0, h2, h1), ...stack]);
        } else if (!fb) {
            let chr = 0;
            for (let i = 0; i < 9; ++i) {
                chr += (read_bit(infl)?1:0) << (8-i);                
            }
            return aux(read_bit(infl), [new Leaf(chr, 0), ...stack]);
        } else {
            throw new Error("Wrong encoding");
        }
    }
    return aux(read_bit(infl), []);
}

function decode_text(infl, tr) {
    let acc = "";
    let node = tr;
    while (node.chr  !== 256) {
        if (node instanceof Leaf) {
            acc = acc + String.fromCharCode(node.chr)
            node = tr;
        } else if (node instanceof Node && read_bit(infl)) {
            node = node.t2;
        } else if (node instanceof Node) {
            node = node.t1;
        }
    }
    return acc;
}

function deflate(str) {
    const infl = new InBitFile(str);
    const tr = decode_tree(infl);
    return decode_text(infl, tr);
}
