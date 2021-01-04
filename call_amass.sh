target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		sudo cp domains /tmp/snap.amass/tmp/domains
		sudo cp ${RECON_BASH_BASEPATH}/amass_config.ini /tmp/snap.amass/tmp/amass_config.ini
		
		if [ -f "domains" ]; then
			sudo amass enum -config /tmp/amass_config.ini -df /tmp/domains -o /tmp/amass_final
		fi
		sudo cat /tmp/snap.amass/tmp/amass_final >> domains_final
		python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py domains_final
		sort -u -o domains_final domains_final
	fi
	# echo `pwd`
done