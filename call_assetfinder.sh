findassets() {
	path="$TARGETS_PATH/$1/"
	cd $path
	if [ -f "domains" ]; then
		for d in $(cat "domains"); do
			assetfinder --subs-only $d | anew domains_final
			python3 ${RECON_BASH_BASEPATH}/python/cleanup_for_scope.py domains_final
			sort -u -o domains_final domains_final
		done
	fi
	# echo `pwd`
}
export -f findassets

parallel -j 8 findassets ::: `ls $TARGETS_PATH/`
