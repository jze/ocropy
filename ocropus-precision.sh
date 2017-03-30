#!/bin/sh
MODEL=$1
DIR=$2

if [ ! -e "$MODEL" ]; then
	echo "USAGE: ocropus-precision.sh <MODEL-FILE>"
	exit 1
fi

if [ ! -n "$DIR" ]; then
	DIR=testing
fi

if [ ! -d $DIR ]; then
	echo "Missing directory 'testing' that contains the image and ground truth for test."
	exit 1
fi

TEMP=`mktemp -d`

cp $DIR/*.png $TEMP
cp $DIR/*.gt.txt $TEMP

ocropus-rpred -q -Q6 -n -m $MODEL $TEMP/*.png
ocropus-econf $TEMP/*.gt.txt 
ocropus-errs -e $TEMP/*.gt.txt 

# Create a correction.html file that contains lines with differences. This file can be used to spot typos in the ground truth.
#WITHDIFF=`ocropus-errs $TEMP/*.gt.txt 2>/dev/null |grep -v "^     0" | cut -b 15- | sed 's/.gt.txt/.png/' `
#ocropus-gtedit html $WITHDIFF

rm -fr $TEMP
