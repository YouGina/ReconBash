target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "hosts" ]; then
			mkdir "$path/dirsearch_output"
			COUNTER=0
			for h in $(cat hosts); do
				python3 ~/tools/discovery/dirsearch/dirsearch.py -b -t 100 -e . -u $h --plain-text-report="$path/dirsearch_output/$COUNTER"
				COUNTER=$[$COUNTER +1]
			done;
		fi
	fi
done

