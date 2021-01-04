#!/bin/bash
target=$1
file=$2
if [ -z "$file" ]; then
	file="domains"
fi
echo $file
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f $file ]; then
			for d in $(cat $file); do
				resultfile="sublist3r_${d}_finall"
				python3 /home/yougina/tools/discovery/sublist3r/sublist3r.py -d $d -o $resultfile
				cat $resultfile | tee -a domains_final
				# python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py domains_final
				sort -u -o domains_final domains_final
			done
		fi
	fi
	# echo `pwd`
done


