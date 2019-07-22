#!/bin/bash
#
# author: Nastasia Vanderperren (PACKED/VIAA)
# goal: use exiftool to recursive write out 
# exif metadat of images in a csv file exiftool.csv
# requires: exiftool to be installed
# use sudo apt install libimage-exiftool-perl
#


folder=$1
outputfolder=$2

exiftool -recurse -csv -ext jpg -ext tif -ext jpeg -ext tiff \
$folder > $outputfolder/exiftool.csv

