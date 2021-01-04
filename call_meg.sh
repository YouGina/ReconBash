target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "hosts" ]; then
			meg -d 1000 -v /
		fi
	fi
        # echo `pwd`
done

