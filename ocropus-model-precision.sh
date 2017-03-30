#!/bin/sh

# Create a plot of the model precision during the training of a model.
# You get a graph showing the error rate for training and testing data to
# check if you ran into overfitting.

echo "# iteration\ttesting\ttraining" > errors.csv

for m in *.pyrnn.gz; do
	echo $m
	n=`echo "$m" | sed 's/^.*-0//' | sed 's/.pyrnn.gz//'`
	p1=`ocropus-precision.sh $m testing |tail -n1` 
	
	if [ "$1" != "testing" ] ; then
		p2=`ocropus-precision.sh $m training |tail -n1` 
	fi
	echo "$n\t$p1\t$p2"  >> errors.csv
done
