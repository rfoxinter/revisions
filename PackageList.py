from os import listdir as l
from os import chdir as c
from os.path import dirname as d
from os.path import splitext as s
from os.path import isdir as i

c(d(__file__) + '/output')
f = open('./packages.txt', 'w')
content = ''
for file in sorted(l('.')):
    if not i(file) and not s(file)[1] in ['.tex', '.txt']:
        content += file + '\n'
f.write(content[0:len(content)-1])
f.close()