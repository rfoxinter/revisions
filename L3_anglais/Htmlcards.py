from subprocess import run as rn
from subprocess import PIPE
from os import chdir as c
from os import remove as rem
from os import rename as ren
from os import makedirs as m
from os import listdir as l
from os.path import realpath as rp
from os.path import dirname as d
from os.path import exists as e
from os.path import splitext as sp
from platform import system
from re import sub as sb
from time import sleep as sl
from argparse import ArgumentParser
c(d(__file__))

def b(a:str) -> bool:
    if 'True' in a:
        return True
    if 'False' in a:
        return False
    raise ValueError('The value is not a Boolean')

p = ArgumentParser()
p.add_argument('--file', type = str, help = 'File to compile', default = '')
p.add_argument('--dest', type = str, help = 'Destination folder', default = 'default')
p.add_argument('--open', type = b, help = 'Open destination folder after generating pdfs', default = 'False')
args = p.parse_args()

def remove_special_chars(s:str) -> str:
    s = sb(u'[ \'’]', '', s)
    s = sb(u'[àáâä]', 'a', s)
    s = sb(u'[èéêë]', 'e', s)
    s = sb(u'[îï]', 'i', s)
    s = sb(u'[ôö]', 'o', s)
    s = sb(u'[ùúûü]', 'u', s)
    s = sb(u'[ç]', 'c', s)
    s = sb(u'[ÀÁÂÄ]', 'A', s)
    s = sb(u'[ÈÉÊË]', 'E', s)
    s = sb(u'[ÎÏ]', 'I', s)
    s = sb(u'[ÔÖ]', 'O', s)
    s = sb(u'[ÙÚÛÜ]', 'U', s)
    s = sb(u'[Ç]', 'C', s)
    return s

def output_f(files:list) -> list:
    ret = []
    for i in files:
        r = open(i, 'r', encoding='utf-8').read()
        st = r.find('{pdftitle=')
        k = st + 11
        while r[k] != '}':
            k += 1
        t = r[st + 10:k]
        dest = t.split('--')
        if len(dest) == 1:
            dest = 'pdf/'
        else:
            dest = 'pdf/' + remove_special_chars(dest[0].title()) + '/'
        ret.append(dest)
    return ret

def gen_latex(r:list, t:str, ttle:str, dest:str, num:str = '') -> bool:
    c(d(__file__))
    fail = False
    qr = ['Q', 'R']
    fst = []
    sh_quest, sh_qr, defs = b(r[1]), b(r[2]), r[3]
    r = list(filter(lambda x: x != [''], [r[i].split(';;') for i in range(4, len(r))]))
    htmlttle = t.split(' -- ')
    if len(htmlttle)==1:
        htmlttle = htmlttle[0]
    else:
        htmlttle = htmlttle[0] + ' &ndash; <i>' + htmlttle[1] + '</i>'
    print('Compilation in progress' + num + '\n')
    for i in range(len(r)):
        for j in range(2):
            noborder = 'tikzpicture' in r[i][j]
            file = '''\\documentclass[12pt''' + (',border=0.5pt' if not noborder else '') + ''']{standalone}
\\usepackage{htmlpreambule}
''' + defs + '''
\\begin{document}
\\begin{adjustbox}{varwidth=10cm}
\\begin{center}
'''
            if r[i][j][0:5] == '!!fst':
                r[i][j] = r[i][j].replace('!!fst', '')
                fst.append(1)
            elif j == 0:
                fst.append(0)
            file += sb(r'\\\\\\\\', r'\\\\', sb(r'\\linebreak', r'\\\\', r[i][j]))
            file += '''
\\end{center}
\\end{adjustbox}
\\end{document}'''
            f = open('output/flcrd.tex', 'w', encoding='utf-8')
            f.write(file)
            f.close()
            c('output/')
            output = rn('latex -interaction=nonstopmode -file-line-error flcrd', shell = True, stdout = PIPE, stderr = PIPE, text = True).stdout
            if 'Command for \'latex\' gave return code 1' in output:
                print(output + '\n')
                fail = True
            ext = ['.aux', '.fdb_latexmk', '.fls', '.log', '.nav', '.out', '.snm', '.synctex.gz', '.toc']
            for k in ext:
                try:
                    rem('flcrd' + k)
                except OSError:
                    pass
            _ = rn('dvisvgm --font-format=woff2 flcrd.dvi ' + ('--bbox=papersize' if not noborder else '') + ' -o ' + ttle + qr[j] + str(i + 1) + '.svg', shell = True, stdout = PIPE, stderr = PIPE, text = True, check = True).stdout
            rem('flcrd.dvi')
            rem('flcrd.tex')
            c('../')
            if not e(dest + '/' + ttle):
                try:
                    m(dest + '/' + ttle)
                except OSError:
                    fail = True
            try:
                ren('output/' + ttle + qr[j] + str(i + 1) + '.svg', dest + ttle + '/' + qr[j] + str(i + 1) + '.svg')
            except:
                fail = True
    c(dest + '/' + ttle)
    f = open('info.txt', 'w', encoding='utf-8')
    f.write('"' + htmlttle + '"\n' + ('1' if sh_quest else '0') + '\n' + ('1' if sh_qr else '0') + '\n' + str([i for i in range(1, len(r) + 1)]) + '\n' + str(fst))
    f.close()
    c('../../')
    return fail

def recompile(dest:str) -> bool:
    fail = False
    files = sorted(l('input/'))
    olddest = dest
    for i, f in enumerate(files):
        f = f.replace('.txt','')
        c(d(__file__))
        try:
            r = open('input/' + f + '.txt', 'r', encoding='utf-8').read().split('\n')
        except OSError:
            raise RuntimeError('File not found')
        t, ttle = '', ''
        if '!ttle' in r[0]:
            ttle, t = r[0].split('!!ttle')
        else:
            t = r[0]
            ttle = t.split('--')
            if len(ttle) == 1:
                ttle = ttle[0].title()
            else:
                ttle = ttle[1].title()
            ttle = remove_special_chars(ttle)
        if dest == 'default':
            dest = t.split('--')
            if len(dest) == 1:
                dest = 'flashcards/'
            else:
                dest = 'flashcards/' + remove_special_chars(dest[0].title()) + '/'
        print('[' + str(i + 1) + '/' + str(len(files)) + ']\nCompilation of [' + f + ']')
        fail &= gen_latex(r, t, ttle, dest)
        dest = olddest


def main(file_path:str, file:str, dest:str, _open:bool) -> bool:
    c(d(__file__))
    fail = False
    if file == '__compile_all__':
        return recompile(dest)
    c(d(rp(file_path)))
    if file == '':
        file = input('File to compile : ')
    try:
        r = open('input/' + file + '.txt', 'r', encoding='utf-8').read().split('\n')
    except OSError:
        raise RuntimeError('File not found')
    t, ttle = '', ''
    if '!ttle' in r[0]:
        ttle, t = r[0].split('!!ttle')
    else:
        t = r[0]
        ttle = t.split('--')
        if len(ttle) == 1:
            ttle = ttle[0].title()
        else:
            ttle = ttle[1].title()
        ttle = remove_special_chars(ttle)
    if dest == 'default':
        dest = t.split('--')
        if len(dest) == 1:
            dest = 'flashcards/'
        else:
            dest = 'flashcards/' + remove_special_chars(dest[0].title()) + '/'
    fail = gen_latex(r, t, ttle, dest)
    if _open:
        sl(.5)
        if system() == 'Windows':
            if rn('start ' + dest, shell = True, stdout = PIPE, stderr = PIPE, text = True).stdout != '':
                print('Unable to open the folder\n')
        else:
            if rn('open ' + dest, shell = True, stdout = PIPE, stderr = PIPE, text = True).stdout != '':
                print('Unable to open the folder\n')
    return fail

if __name__ == '__main__':
    if main(__file__, sp(args.file)[0], args.dest, args.open):
        raise RuntimeError('An error has occurred')
    print('Compilation complete')