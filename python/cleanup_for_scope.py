import sys
import os
from urllib.parse import urlparse

def checkOutOfScope(items):
	out_scope_wildcard = None
	out_scope_others = None
	if os.path.exists("out_scope_wildcard"):
		with open("out_scope_wildcard", "r") as f:
			out_scope_wildcard = f.read().splitlines()
			for item in out_scope_wildcard:
				items = [ x for x in items if item not in x ]

	if os.path.exists("out_scope_others"):
		with open("out_scope_others", "r") as f:
			out_scope_others = f.read().splitlines()
			for item in out_scope_others:
				items = [ x for x in items if item not in x ]
	return items

def checkInScope(items):
	scope_wildcard = None
	scope_others = None
	if os.path.exists("scope_wildcard"):
		with open("scope_wildcard", "r") as f:
			scope_wildcard = f.read().splitlines()
	if os.path.exists("scope_others"):
		with open("scope_others", "r") as f:
			scope_others = f.read().splitlines()
	result = []
	for item in items:
		remove = 0
		if scope_others is not None:
			for s in scope_others:
				if s in item:
					remove = remove + 1

		if scope_wildcard is not None:
			for s in scope_wildcard:
				if s in item:
					remove = remove + 1
		if remove != 0:
			result.append(item)
	return result


file = sys.argv[1]
items = []
if os.path.exists(file):
	with open(file, "r") as f:
		items = f.read().splitlines()
	oldlist = items
	items = checkOutOfScope(items)
	items = checkInScope(items)
	
	with open(file, "w") as f:
		for item in items:
			f.write(item+"\n")


