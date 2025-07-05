from os import listdir as l
from os import chdir as c
from os.path import dirname as d
from os.path import splitext as s
from os.path import isdir as i

def read_content(dir):
    dirpath = ''
    if dir != '.':
        dirpath = dir + '/'
    content = ''
    for file in sorted(l(dir)):
        if not i(file) and not s(file)[1] in ['.cls', '.tex', '.txt']:
            content += dirpath + file + '\n'
        elif i(file):
            content += read_content(dirpath + file)
    return content

c(d(__file__) + '/output')
f = open('./packages.txt', 'w')
content = ''
content = read_content('.')
f.write(content[0:len(content)-1])
f.close()