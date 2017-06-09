#!/bin/bash

# This script performs some basic tests on the ground truth data.
#
# The script expected the training data in a directory called training/
# and the test data in a  directory called testing/
#
# If no codec.txt file is present, it will be generated from all characters
# contained in training and test data.


txtbld=$(tput bold) 
bldred=${txtbld}$(tput setaf 1) #  red
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset


if [ ! -d training ]; then
	echo "${bldred}ERROR:${txtrst} Missing training/ directory."
	exit 1
fi
if [ ! -d testing ]; then
	echo "${bldred}ERROR:${txtrst} Missing testing/ directory."
	exit 1
fi


cat testing/*.gt.txt | sed 's/\(.\)/\1\n/g'| sort | uniq |grep -v '^$' > chars-testing.txt
cat training/*.gt.txt | sed 's/\(.\)/\1\n/g'| sort | uniq |grep -v '^$'  > chars-training.txt

if [ -e codec.txt ] ; then 
	cat codec.txt  | sed 's/\(.\)/\1\n/g' | sort | uniq |grep -v '^$' > chars-codec.txt
else
	echo -e "${bldwht}INFO:${txtrst} No codec specified. Generating codec based on training and test data."
	cat testing/*.gt.txt training/*.gt.txt | sed 's/\(.\)/\1\n/g'| sort | uniq | tr -d '\n' > codec.txt
fi

diff chars-codec.txt  chars-training.txt |grep -q '^>'  
if [ $? -eq 0  ]; then
	echo -e "${bldred}WARNING:${txtrst} Training data contains characters not included in the codec:"
	diff  chars-codec.txt  chars-training.txt |grep '^>' |cut -c 3- | tr -d '\n'
	echo
fi

diff  chars-codec.txt  chars-training.txt |grep -q  '^<' 
if [ $? -eq 0  ]; then
	echo -e "${bldred}WARNING:${txtrst} Missing training data for these characters:"
	diff  chars-codec.txt  chars-training.txt  |grep '^<' |cut -c 3-| tr -d '\n'
	echo
fi

diff chars-codec.txt  chars-testing.txt |grep -q '^>'  
if [ $? -eq 0  ]; then
	echo -e "${bldred}WARNING:${txtrst} Test data contains characters not included in the codec:"
	diff  chars-codec.txt  chars-testing.txt |grep '^>' |cut -c 3- | tr -d '\n'
	echo
fi


diff chars-training.txt  chars-testing.txt |grep -q '^>'  
if [ $? -eq 0  ]; then
	echo -e "${bldred}WARNING:${txtrst} Test data contains characters not included in the training data:"
	diff  chars-training.txt  chars-testing.txt |grep '^>' |cut -c 3- | tr -d '\n'
	echo
fi

diff  chars-training.txt  chars-testing.txt |grep -q  '^<' 
if [ $? -eq 0  ]; then
	echo -e "${bldred}WARNING:${txtrst} Missing test data for these characters:"
	diff  chars-training.txt  chars-testing.txt  |grep '^<' |cut -c 3-| tr -d '\n'
	echo
fi
