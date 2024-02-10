from re import sub
from re import search
from re import escape
from . import tools

def line_transform(line: str) -> str:
    text = tools.get_text(line)
    if not '∂' in text:
        return line
    if not 'transform' in line:
        if not '∂</tspan>' in line:
            if len(text) == 1:
                return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6)) + ' 0)\'>', line, count=1)
            l1 = line[0:search('∂', line).start() + 1] + '</text>'
            l2 = sub('∂', '', line)
            return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6)) + ' 0)\'>', l1, count=1) + '\n' + l2
        if len(text) == 1:
            return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6)) + ' 0)\'>', line, count=1)
        l1 = sub('>.*?<tspan', '><tspan', line[0:search('∂', line).start() + 1], count=1) + '</tspan></text>'
        (tspan, (x, y)) = tools.get_tspan(l1)
        l1 = sub('y=\'-?[0-9]*\.?[0-9]*\'', 'y=\'' + str(y) + '\'', sub('x=\'-?[0-9]*\.?[0-9]*\'', 'x=\'' + str(x) + '\'', l1))
        l2 = sub('∂', '', line)
        return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round((-tools.get_y(line) - tools.get_x(l2) + x) / 4, 6)) + ' 0)\'>', sub('<tspan.*?</tspan>', tspan, l1), count=1) + '\n' + l2
    if not '∂</tspan>' in line:
        (transform, (dx, dy)) = tools.get_transform(line)
        if len(text) == 1:
            return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6) + dx) + ' ' + str(dy) + ')\'>', sub(escape(transform), '', line, count=1), count=1)
        l1 = line[0:search('∂', line).start() + 1] + '</text>'
        l2 = sub('∂', '', line)
        return sub('>', ' transform=\'matrix(1 0 0.25 1 ' + str(round(-tools.get_y(line) / 4, 6) + dx) + ' ' + str(dy) + ')\'>', sub(escape(transform), '', l1, count=1), count=1) + '\n' + l2
    print('∂ left unchanged in ' + line)
    return line

def main(flnm: str) -> None:
    f = open(flnm, 'r', encoding='UTF-8').readlines()
    for i in range(len(f)):
        f[i] = line_transform(f[i])
    w = open(flnm, 'w', encoding='UTF-8')
    w.writelines(f)
    w.close()