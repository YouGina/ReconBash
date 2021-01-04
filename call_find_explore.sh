target=$1
for dir in $(ls $TARGETS_PATH/); do
	if ([ -z "$target" ] || [ $target = $dir ]); then
		path="$TARGETS_PATH/$dir/"
		cd $path
		if [ -f "hosts" ]; then
			meg --savestatus 200 -v /explore hosts out_explore
		fi
	fi
        # echo `pwd`
done

