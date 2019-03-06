#!/bin/bash
#
# author: Nastasia Vanderperren (PACKED/VIAA)
# goal: collect all tif images, store them in a temporary folder and 
# check if they are TIFF baseline comformant. store the reports in pdf.
#
##############################

## variables
parentfolder=$1
outputfolder=$2
tempfolder=~/tiftemp

## find all the tifs and store them in a temp folder
mkdir $tempfolder
find $parentfolder/ -type f \( -name '*.jpg' -o -name '*.JPG' \) -exec rsync -a {} $tempfolder \; # test with jpg for now

# do dpf-manager stuff
# when ready delete the folder rm -r $tempfolder
