#!/usr/bin/python3

import sys

lines = []
for line in sys.stdin:
	if line.count("/") == 0 and ".js" in line:
		lines.append(line)
	if line.count("/") >= 1:
		lines.append(line.split('/')[-1].replace("\\", ""))
	if line.count("/") >= 1 and ".js" in line:
		lines.append(line)
	if line.startswith("http") or line.startswith("//"):
		lines.append(line.split("/",3)[-1].replace("\\", ""))

for line in lines:
	line = line.replace("\n", "").replace("'", "")
	if line != "" and len(line) < 2000:
		print(line)
