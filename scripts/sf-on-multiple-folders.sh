#!/bin/bash
#
# Author: Nastasia Vanderperren (PACKED/VIAA)
# Goal: do a SF analysis on a selection of folders
#

i=1
destination=~/Desktop/$1
# mkdir $destination # uncomment this step if your folder is not yet created

while (( $# ))
do    
    folder=$2

    if [[ $folder == "" ]]; then
        echo "do nothing"
    else
        folder_name=`basename "$folder"`
        echo "$folder_name"
        cd $folder # go into the folder
        echo "$i) BUSY WITH $folder_name"
        sf -csv -coe -hash md5 "$folder" > "$destination/siegfried_folder_$i.csv"
        echo "- $folder done"
        let i++;
    fi
    shift
done