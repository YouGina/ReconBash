#!/bin/bash

target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "domains" ]; then
			sort -u -o domains domains
			for d in $(cat "domains"); do
				assetfinder --subs-only $d | tok -delim-exceptions=- | sort -u | tee -a "$d-wordlist.txt"
			done
			cat domains_final | tok -delim-exceptions=- | sort -u | tee -a "$target-wordlist.txt"
		fi
	fi
	# echo `pwd`
done


