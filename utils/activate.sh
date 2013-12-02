if [ `find | grep activate$ | wc -l` == 1 ]; then
    source `find | grep activate$`
fi
