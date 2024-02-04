from re import findall
from re import sub

def get_text(line: str) -> list[str]:
    return list(filter(lambda x: x  != '', map(lambda x: sub('>', '', sub('<', '', x)), findall('>.*?<', line))))

def get_y(line: str) -> float:
    return float(sub('y=', '', sub('\'', '', findall('y=\'-?[0-9]*\.?[0-9]*\'', line)[0])))