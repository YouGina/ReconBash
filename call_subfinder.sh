#!/bin/bash

target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "domains" ]; then
			for d in $(cat "domains"); do
				resultfile="subfinder_${d}_finall"
				subfinder -d $d -silent | tee -a $resultfile
				till_here=$(grep -n "Unique subdomains" $resultfile | cut -d":" -f1)
				sed -i -e "1,$till_here d" -e '/^$/d' -e 's/^\.//' $resultfile
				cat $resultfile | tee -a domains_final
				# python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py domains_final
				sort -u -o domains_final domains_final
			done
		fi
	fi
	# echo `pwd`
done


