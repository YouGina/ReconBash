target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
	        path="$TARGETS_PATH/$dir/"
        	cd $path

		mkdir -p $path/base64_decoded_strings
		COUNTER=1
		for line in $(gf base64); do
			echo $line | awk -F ':' '{print $1}' > base64_decoded_strings/$COUNTER
			if [[ $line == *"%"* ]]; then
				echo $line | while read; do echo -e ${REPLY//%/\\x}; done | awk -F ':' '{print $3}' | cut -c2- | base64 -d >> base64_decoded_strings/$COUNTER
			else
				echo $line | awk -F ':' '{print $3}' | cut -c2- | base64 -d >> base64_decoded_strings/$COUNTER
			fi
	 		COUNTER=$[$COUNTER +1]
		done
	fi
done

