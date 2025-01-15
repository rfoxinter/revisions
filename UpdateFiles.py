from os import listdir as l
from os import chdir as c
from os import makedirs as mds
from os.path import dirname as d
from os.path import exists as e
from os.path import join as j
from os.path import getmtime as g
from os.path import splitext as s
from shutil import copyfile as cp
from argparse import ArgumentParser

p = ArgumentParser()
p.add_argument('--folder', type = str, help = 'Folder to update files', default = '')
args = p.parse_args()
folder = args.folder
if folder == '':
    folder = input('Folder to update files : ')

c(d(__file__))
files = [("","CardsList.py"), ("","Flashcards.py"), ("","Htmlcards.py")]
for file in l('./output'):
    if not s(file)[1] in [".cls", ".tex", ".txt"]:
        files.append(("output/", file))
for file in l('./edit_svg'):
    if s(file)[1] != ".pyc" and file != "__pycache__":
        files.append(("edit_svg/", file))
for (path, file) in files:
    destpath = j(folder, path)
    if not e(destpath):
        mds(destpath)
    destfile = j(destpath + file)
    if e(destfile):
        if g(j(path, file)) > g(destfile):
            cp(j(path, file), destfile)
    else:
        cp(j(path, file), destfile)