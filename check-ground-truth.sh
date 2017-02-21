#!/bin/bash

# This script collect those ground truth image snippets for which the
# OCR did not produce the expected text. Maybe there is a typo in the 
# ground truth text.
	
DIFFS=`mktemp`
ocropus-errs testing/${1}*.gt.txt training/${1}*.gt.txt 2>/dev/null |grep -v "^     0" | grep gt.txt| cut -b 15- | sed 's/.gt.txt//' > $DIFFS
	
# copy ground truth text to make it accessable for ocropus-gtedit
cat $DIFFS | while read f; do cp $f.gt.txt $f.txt; done
ocropus-gtedit html `cat $DIFFS | sed 's/$/.bin.png/'`
	
rm -f $DIFFS

