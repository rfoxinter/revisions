from urllib import request
from os.path import exists
from os import mkdir, chdir

files = request.urlopen("https://rfoxinter.github.io/revisions/output/packages.txt").read().decode("utf-8")
print(files)
if not exists("./output"):
    mkdir("./output")
chdir("./output")
for file in files.splitlines():
    print(file)
    request.urlretrieve("https://rfoxinter.github.io/revisions/output/" + file, file)