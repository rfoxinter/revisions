from re import findall
from re import sub

def get_text(line: str) -> list[str]:
    return list(filter(lambda x: x  != '', map(lambda x: sub('>', '', sub('<', '', x)), findall('>.*?<', line))))

def get_x(line: str) -> float:
    return float(sub('x=', '', sub('\'', '', findall(r'x=\'-?[0-9]*\.?[0-9]*\'', line)[0])))

def get_y(line: str) -> float:
    return float(sub('y=', '', sub('\'', '', findall(r'y=\'-?[0-9]*\.?[0-9]*\'', line)[0])))

def get_transform(line: str) -> tuple[str, tuple[float, float]]:
    transform = findall(r'transform=\'matrix\(.*?\)\'', line)[0]
    return transform, list(map(float, sub(r'transform=\'matrix\(', '', sub(r'\)\'', '', transform)).split(' ')[4:6]))

def get_tspan(line: str) -> tuple[str, tuple[float, float]]:
    tspan = findall('<tspan.*?</tspan>', line)[0]
    return (get_text(tspan)[0], (get_x(tspan), get_y(tspan)))