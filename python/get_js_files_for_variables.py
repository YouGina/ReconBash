import sys

file = sys.argv[1]

startWriting = False
foundNewLine = False
foundHeader = False


with open(file) as f:
	for line in f.readlines():
		if startWriting and foundHeader:
			print(line.replace("\n", ""))
		if line.startswith("<"):
			foundHeader = True
		if foundHeader and line == "\n":
			startWriting = True

