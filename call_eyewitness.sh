cat $TARGETS_PATH/*/*out*/index | awk -F' ' '{print $2}' | grep -v '\.js\|\.css\|\.svg$\|\.gif$\|\.png$\|\.jpg$\|\.ico$\|\.eot$\|\.ttf$\|\.wav$' | shuf
