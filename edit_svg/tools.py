from re import findall
from re import sub

def get_text(line: str) -> list[str]:
    return list(filter(lambda x: x  != '', map(lambda x: sub('>', '', sub('<', '', x)), findall('>.*?<', line))))

def get_y(line: str) -> float:
    return float(sub('y=', '', sub('\'', '', findall('y=\'-?[0-9]*\.?[0-9]*\'', line)[0])))

def get_transform(line: str) -> tuple[str, tuple[float, float]]:
    transform = findall('transform=\'matrix\(.*?\)\'', line)[0]
    return transform, list(map(float, sub('transform=\'matrix\(', '', sub('\)\'', '', transform)).split(' ')[4:6]))