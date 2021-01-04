target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
	        path="$TARGETS_PATH/$dir/"
        	cd $path
		if [ -d "outjs" ]; then
			for d in $(ls "outjs/"); do
				if [ $d != "index" ]; then
					for f in $(ls "outjs/$d"); do
						ruby ~/tools/discovery/relative-url-extractor/extract.rb $path/outjs/$d/$f >> $path/js_extracted_urls
					done;
				fi
			done
		fi
		if [ -f "js_extracted_urls" ]; then
			sort -u -o js_extracted_urls js_extracted_urls
		fi
	fi
done

