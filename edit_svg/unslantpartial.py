from re import sub
from re import search
from re import escape
from . import tools

def line_transform(line: str) -> str:
    text = tools.get_text(line)
    if not '∂' in text:
        return line
    if not 'transform' in line:
        if len(text) == 1:
            return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6)) + ' 0)\'>', line, count=1)
        l1 = line[0:search('∂', line).start() + 1] + '</text>'
        l2 = sub('∂', '', line)
        return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6)) + ' 0)\'>', l1, count=1) + '\n' + l2
    (transform, (dx, dy)) = tools.get_transform(line)
    if len(text) == 1:
        return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6) + dx) + ' ' + str(dy) + ')\'>', sub(escape(transform), '', line, count=1), count=1)
    l1 = line[0:search('∂', line).start() + 1] + '</text>'
    l2 = sub('∂', '', line)
    return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6) + dx) + ' ' + str(dy) + ')\'>', sub(escape(transform), '', l1, count=1), count=1) + '\n' + l2

def main(flnm: str) -> None:
    f = open(flnm, 'r', encoding='UTF-8').readlines()
    for i in range(len(f)):
        f[i] = line_transform(f[i])
    w = open(flnm, 'w', encoding='UTF-8')
    w.writelines(f)
    w.close()