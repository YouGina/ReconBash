target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "domains_final" ]; then
			if [ -f "masscan_remove_me" ]; then
				echo "Masscan exists for $dir"
				check=""
				for p in $(cat masscan | awk -F' ' '{print $3}' | sort -u); do
					check="$check -p http:$p -p https:$p"
				done;
				echo "Start running httprobe with $check"
				cmd="httprobe -c 50 $check"
				cat domains_final | shuf | $cmd | tee -a hosts_with_ports
			else
				cat domains_final | shuf | httprobe -c 40 -p xlarge | tee -a hosts_with_ports # hosts
			fi
			python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py hosts
		fi
		# echo `pwd`
		if [ -f "hosts" ]; then
			sort -u -o hosts hosts
		fi
		if [ -f "hosts_with_ports" ]; then
			sort -u -o hosts_with_ports hosts_with_ports
		fi
	fi
done

