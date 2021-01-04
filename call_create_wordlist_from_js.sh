target=$1
for dir in $(ls $TARGETS_PATH/ | shuf ); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
	        path="$TARGETS_PATH/$dir/"
        	cd $path
		for d in $(ls "outjs/"); do
			for f in $(ls "outjs/$d"); do
				python3 ${RECON_BASH_BASEPATH}/python/get_js_files_for_variables.py $path/outjs/$d/$f > $f.js
				js-identifiers $f.js >> $path/js_var_wordlist
				rm $f.js
			done;
		done
		sort -u -o js_var_wordlist js_var_wordlist
	fi
done

