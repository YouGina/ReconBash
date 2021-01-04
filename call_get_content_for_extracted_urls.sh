target=$1
for dir in $(ls $TARGETS_PATH/ | shuf ); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
	        path="$TARGETS_PATH/$dir/"
        	cd $path
		meg -d 1000 -v js_extracted_urls hosts outextracted
	fi
done

