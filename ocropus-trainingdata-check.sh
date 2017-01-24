#!/bin/sh

# Check the training data for typos. This is done by using a specified model
# (usually one from the current learning process) to prediect the text.
# Lines with differences from the ground truth will be collected in 
# corrections.html file.

MODEL=$1

if [ ! -e "$MODEL" ]; then
	echo "USAGE: ocropus-genauigkeit.sh <MODEL-FILE>"
	exit 1
fi

if [ ! -d training ]; then
	echo "Missing directory 'training' that contains the image and ground truth for test."
	exit 1
fi


ocropus-rpred -q -Q6 -m $MODEL training/*.png
ocropus-errs training/*.gt.txt 
# Create a correction.html file that contains lines with differences. This file can be used to spot typos in the ground truth.
WITHDIFF=`ocropus-errs training/*.gt.txt 2>/dev/null |grep -v "^     0" | cut -b 15- | sed 's/.gt.txt/.png/' `
ocropus-gtedit html $WITHDIFF
