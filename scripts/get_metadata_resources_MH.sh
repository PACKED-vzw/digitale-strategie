#!/bin/bash
#
# Author: Nastasia Vanderperren (PACKED/VIAA)
# Goal: generate a CSV that is used to import Siegfried data in a MySQL database and a CSV with the fragment IDs for each item in Mediahaven.
# 
# Example usage:
# sh get_metadata_resources_MH.sh ${TOKEN} ${name of the organisation} ${id of the ingest space in Mediahaven}
#
# Dependencies: cURL, jq


# parameters
token=$1
organisation=$2
invoerruimte=$3

# final variables csv fields
header_database="filename,filesize,modified,errors,md5,namespace,id,format,version,mime,basis,warning,server,organisation"
header_download="fragment_id,filename,extension"
errors="geen siegfried check!"
warning="geen siegfried check!"
server="Mediahaven"

# final variables storage
output=../output
folder="${output}/${organisation}"
csv_database="${folder}_database_MH.csv"
csv_download="${folder}_download_MH.csv"

# functions

# MH doesn't to file identification. it only stores the orginal file extension. this function converts the extension to a certain filetype
function getFileType {
    extension=$1
    case $extension in 
        jpg)
            filetype="Raw JPEG Stream"
        ;;
        tif)
            filetype="Exchangeable Image File Format (Uncompressed)"
        ;;
    esac
    echo $filetype
}

# a call to get the total amount of resources in the ingest space
# this is used in the main script to get the metadata of all the resources in the ingest space
function getAantal {
    aantal=$(curl -s -X GET \
    -H "Authorization: Bearer ${token}" \
    -H 'Accept: application/vnd.mediahaven.v2+json' \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/?q=%2B(IngestSpaceId:%22${invoerruimte}%22)%20%2B(IsInIngestSpace%3A1)&nrOfResults=1" \
    | jq .TotalNrOfResults)
    echo $aantal
}

# the metadata of all the resouces in Mediahaven are stored in a json file
function doCallMediaHaven {
    aantal=$1
    curl -s -X GET \
    -H "Authorization: Bearer ${token}" \
    -H 'Accept: application/vnd.mediahaven.v2+json' \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/?q=%2B(IngestSpaceId:%22${invoerruimte}%22)%20%2B(IsInIngestSpace%3A1)&nrOfResults=${aantal}" \
    | jq .MediaDataList > "${folder}_MH.json"

    echo "${folder}_MH.json"
}

# function to create the two csv's
function createCSVs {
echo $header_database > "$csv_database"
echo $header_download > "$csv_download"
echo "bezig met de beelden van $organisation!"

    aantal=$(getAantal)
    echo $aantal
    #aantal=10

    json=$(doCallMediaHaven $aantal)

    for i in $(seq 0 $((aantal-1))) 
    do 
        echo "busy with nr. $((i+1))"
        fragment_id=$(jq -r .[$i].Internal.FragmentId $json)
        extension=$(jq -r .[$i].Technical.OriginalExtension $json)
        filename=$(jq -r .[$i].Descriptive.OriginalFilename $json)
        filesize=$(jq -r .[$i].Technical.FileSize $json)
        format=$(getFileType $extension)
        modified=$(jq -r .[$i].Administrative.LastModifiedDate $json)
        md5=$(jq -r .[$i].Technical.Md5 $json)
        mime=$(jq -r .[$i].Technical.MimeType $json)

        echo $fragment_id,$filename,$extension >> "$csv_download"
        echo $filename,$filesize,$modified,$errors,$md5,,,$format,,$mime,,$warning,$server,$organisation >> "$csv_database"
    done
    echo "finished! done done done"
}


## main script

if [ ! -d ${output} ]
then
    mkdir ${output}
fi

createCSVs

# improvements: combine the multiple jq calls to one call