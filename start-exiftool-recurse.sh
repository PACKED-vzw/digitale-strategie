#!/bin/bash
#
# author: Nastasia Vanderperren (PACKED/VIAA)
# goal: use exiftool to recursive write out 
# exif metadata of images in a csv file exiftool.csv
# it searches recursive to files with mimetype jpeg and tif
# requires: exiftool to be installed
# use sudo apt install libimage-exiftool-perl
#


folder=$1
outputfolder=$2

exiftool -recurse -csv -ext jpg -ext jpeg -ext tif -ext tiff $folder > $outputfolder/exiftool.csv

