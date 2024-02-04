from re import search
from . import unslantpartial

def main(imports: str, flnm: str) -> None:
    if search('\\\\usepackage\\[?([a-z]*-*[A-Z]*)*\\]?\\{analyse\\}', imports) and not search('\\\\resetpartial', imports):
        unslantpartial.main(flnm)
    return