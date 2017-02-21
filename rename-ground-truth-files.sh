#!/bin/sh

# USAGE: rename-ground-truth-files.sh <PREFIX>

# Searches a directory for files with a name ending with gt.txt and renames
# the text file and the correcponding bin.png file to 
# PREFIX_[MD5sum of image file]

if [ -z "$1" ]; then
	echo "USAGE: rename-ground-truth-files.sh <PREFIX>"
	exit 1
fi

/usr/bin/find . -name "*.gt.txt" | while read t; do 
	PNG="`echo "$t" | sed 's/.gt.txt/.bin.png/'`"
	MD5=`md5sum "$PNG" |  cut -c 1-32`
	mv $t ${1}_${MD5}.gt.txt
	mv $PNG ${1}_${MD5}.bin.png
done
