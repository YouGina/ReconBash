#!/bin/bash

target=$1
for dir in $(ls $TARGETS_PATH/ | shuf); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "scope_wildcard" ]; then
			sort -u -o scope_wildcard scope_wildcard
			for d in $(cat "scope_wildcard"); do
				knockpy -j $d
			done
		fi
	fi
	# echo `pwd`
done


