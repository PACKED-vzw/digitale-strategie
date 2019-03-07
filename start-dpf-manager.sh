#!/bin/bash
#
# author: Nastasia Vanderperren (PACKED/VIAA)
# goal: collect all tif images, store them in a temporary folder and 
# check if they are TIFF baseline comformant. store the reports in pdf.
#
##############################

## variables
parentfolder=$1
outputfolder=$2/dpfmanager
tempfolder=~/tiftemp

## find all the tifs and store them in a temp folder
mkdir $tempfolder
# searches for tif, tiff, TIF and TIFF
find $parentfolder/ -type f \( -name '*.tif*' -o -name '*.TIF*' \) -exec rsync -a {} $tempfolder \; 

# do dpf-manager stuff
dpf-manager check --output $outputfolder --format pdf $tempfolder 

# when ready delete the folder
rm -rf $tempfolder
