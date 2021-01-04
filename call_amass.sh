target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		sudo cp domains /tmp/snap.amass/tmp/domains
		if [ -f "domains" ]; then
			sudo amass enum -config "./amass_config.ini" -df /tmp/domains -o amass_final
		fi
		cat amass_final >> domains_final
		python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py domains_final
		sort -u -o domains_final domains_final
	fi
	# echo `pwd`
done