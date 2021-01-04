#!/bin/bash


target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "massdns_ip.ips" ]; then
			echo "Start for $dir"
			outputFile=masscan

			sudo masscan -iL massdns_ip.ips -p1-65535 --rate=10000 -oL $outputFile -oG ${outputFile}.gnmap
			sed -i -e "/#/d" -e "/^$/d" $outputFile
			cut -d" " -f3,4 $outputFile | awk '{print($2","$1)}' | sort -V > masscan-sorted

		fi
	fi
	# echo `pwd`
done


