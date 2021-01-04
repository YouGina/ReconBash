#!/bin/bash

target=$1
for dir in $(ls $TARGETS_PATH/ | shuf); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "domains" ]; then
			sort -u -o domains domains
			for d in $(cat "domains"); do
				if [ -f "$d-wordlist.txt" ]; then
					python3 /home/yougina/tools/discovery/Syborg/syborg.py -w "$d-wordlist.txt" -o syborg-domains-$d.txt $d
				fi
			done
		fi
	fi
	# echo `pwd`
done


