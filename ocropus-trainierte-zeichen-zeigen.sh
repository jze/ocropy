#!/bin/sh

cat training/*.gt.txt | sed 's/\(.\)/\1\n/g'| sort | uniq -c
