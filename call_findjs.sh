target=$1
for dir in $(ls $TARGETS_PATH/ | shuf ); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
	        path="$TARGETS_PATH/$dir/"
        	cd $path
        	if [ -d "out" ]; then
			echo $path
			gf strings | grep "\.js" | tee js_files

			sed -i 's/\"//g' js_files
			sed -i "s/\'//g" js_files

			sort -u -o js_files js_files

			cat js_files | ${RECON_BASH_BASEPATH}/python/parse_js.py | tee js_files_new
			cat js_files_new > js_files

			sed -i "s/\'//g" js_files
			sed -i -e 's/^/\//' js_files

			sort -u -o js_files js_files

			rm js_files_new
			cat js_files
			echo "Start meg for $path"
			meg -v -d 200 -s 200 js_files hosts outjs
        	fi
	fi
done

