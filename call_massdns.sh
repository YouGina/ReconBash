#!/bin/bash


target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "domains_final" ]; then
			echo "Start for $dir"
			resultfile="massdns_ip"
			massdns_temp=$resultfile.temp
			massdns_ips=$resultfile.ips
			massdns_out=$resultfile.out

			massdns -r /mnt/dataset/lists/resolvers.txt -t A -o S -w $massdns_temp domains_final
			cat $massdns_temp | cut -f1 -d" " | sed -e "s/\.$//g" | sort -u >> $massdns_out
			cat $massdns_temp | cut -d" " -f3 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >> $massdns_ips
			rm $massdns_temp
			cat $massdns_out >> domains_final
			python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py domains_final
			sort -u -o domains_final domains_final
		fi
	fi
	# echo `pwd`
done


