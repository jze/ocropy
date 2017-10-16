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
	NRM="`echo "$t" | sed 's/.gt.txt/.nrm.png/'`"
	
	if [ -e $NRM ] ; then 
		MD5=`md5sum "$NRM" |  cut -c 1-32`
	else
		MD5=`md5sum "$PNG" |  cut -c 1-32`
	fi
	
	mv $t ${1}_${MD5}.gt.txt
	mv $PNG ${1}_${MD5}.bin.png
	if [ -e $NRM ] ; then 
		mv $NRM ${1}_${MD5}.nrm.png
	fi
done
