from random import shuffle as sh
from os import system as s
from os import chdir as c
from os import remove as rem
from os import rename as ren
from os import makedirs as m
from os.path import realpath,dirname
from os.path import dirname as d
from os.path import exists as e
from platform import system
from re import sub
import argparse

def b(a:str) -> bool:
    if 'True' in a:
        return True
    if 'False' in a:
        return False
    raise ValueError

parser=argparse.ArgumentParser()
parser.add_argument('file',type=str)
parser.add_argument('--n',type=int,help='Number of flascards',default=1)
parser.add_argument('--dest',type=str,help='Destination folder',default='default')
parser.add_argument('--open',type=b,help='Open destination folder after generating pdfs',default='False')
args=parser.parse_args()

def remove_special_chars(string:str) -> str:
    string=sub(u"[ ]",'',string)
    string=sub(u"[àáâä]",'a',string)
    string=sub(u"[èéêë]",'e',string)
    string=sub(u"[îï]",'i',string)
    string=sub(u"[ôö]",'o',string)
    string=sub(u"[ùúûü]",'u',string)
    string=sub(u"[ç]",'c',string)
    return string

def gen_latex(r:list,t:str,ttle:str,dest:bool) -> None:
    c(d(__file__))
    sh_quest,sh_qr,defs=b(r[1]),b(r[2]),r[3]
    r = [r[i].split(';;') for i in range(4,len(r))]
    if sh_qr:
        for i in r:
            sh(i)
    if sh_quest:
        sh(r)
    del sh_qr,sh_quest
    t2 = t.split(' -- ')
    if len(t2)==1:
        t2 = t2[0]
    else:
        t2 = t2[0] + '\\\\\\emph{' + t2[1] + '}'
    file = '''\\documentclass[14pt,usepdftitle=false,aspectratio=169]{beamer}
\\usepackage{preambule}
\\setbeamercolor{structure}{fg=black}
''' + defs + '''
\\hypersetup{pdftitle=''' + t + '''}
\\title{''' + t2 + '''}
\\author{}
\\date{}
\\begin{document}
\\begin{frame}
    \\titlepage
\\end{frame}
'''
    del defs,t2
    for i in range(len(r)):
        file += '\\slideq{' + r[i][0] + '}{' + str(i+1) + '/' + str(len(r)) + '}\n'
        file += '\\slider{' + r[i][1] + '}{' + str(i+1) + '/' + str(len(r)) + '}\n'
    file += '\end{document}'
    f = open('output/' + ttle + '.tex','w')
    f.write(file)
    f.close()
    c('output/')
    s('latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf ' + ttle)
    if e('../' + ttle + '.pdf'):
        rem('../' + ttle + '.pdf')
    ext = ['.aux','.fdb_latexmk','.fls','.log','.nav','.out','.snm','.synctex.gz','.toc']
    for i in ext:
        if e(ttle + i):
            rem(ttle + i)
    c('../')
    if not e(dest):
        m(dest)
    ren('output/' + ttle + '.pdf', dest + ttle + '.pdf')

def main(file_path:str,file:str,n:int,dest:str,_open:bool) -> None:
    c(dirname(realpath(file_path)))
    if file=='':
        file = input('Chapitre : ').split(';;')
    r = open('input/'+file+'.txt', 'r').read().split('\n')
    t=r[0]
    ttle = t.split('--')
    if len(ttle)==1:
        ttle=ttle[0].title()
    else:
        ttle=ttle[1].title()
    ttle=remove_special_chars(ttle)
    if dest=='default':
        dest=t.split('--')
        if len(dest)==1:
            dest='pdf/'
        else:
            dest='pdf/'+remove_special_chars(dest[0].title())+'/'
    if n==1:
        gen_latex(r,t,ttle,dest)
    else:
        for j in range(n):
            gen_latex(r,t,ttle+str(j+1),dest)
    if _open:
        if system()=='Windows':
            s('start' + dest)
        else:
            s('open ' + dest)

if __name__=='__main__':
    main(__file__,args.file,args.n,args.dest,args.open)
