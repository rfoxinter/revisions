from os import listdir as l
from os import chdir as c
from os.path import dirname as d
from os.path import exists as e
from os.path import isdir as i
from os.path import getmtime as g
from datetime import datetime as dt
from argparse import ArgumentParser

c(d(__file__) + '/flashcards')
f = open('./cards.txt', 'w')
content = 'https://rfoxinter.github.io/revisions/flashcards/'
global cards
cards = []
def list_f(folder):
    global cards
    curr_cards = []
    for sub_folder in sorted(l(folder), reverse=True):
        if e(folder + '/' + sub_folder + '/info.txt'):
            if folder == '.':
                curr_cards.append('./' + sub_folder)
            else:
                curr_cards.append(folder + '/' + sub_folder)
        elif i(folder + '/' + sub_folder):
            list_f(folder + '/' + sub_folder)
    cards = sorted(curr_cards) + cards
list_f('.')
for c in cards:
    content += '\n../L3S2/flashcards/' + c.replace('./', '') + '\n' + dt.fromtimestamp(g(c)).strftime('%Y%m%d%H%M%S')
f.write(content)
f.close()