#!/bin/bash

token=$1
organisation=$2
invoerruimte=$3
server="Mediahaven"
header_database="filename,filesize,modified,md5,format,mime,server,organisation"
header_download="fragment_id,filename,extension"
csv_database="$organisation"_database_MH.csv
csv_download="$organisation"_download_MH.csv

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

function getAantal {
    aantal=$(curl -s -X GET \
    -H "Authorization: Bearer ${token}" \
    -H 'Accept: application/vnd.mediahaven.v2+json' \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/?q=%2B(IngestSpaceId:%22${invoerruimte}%22)%20%2B(IsInIngestSpace%3A1)&nrOfResults=1" \
    | jq .TotalNrOfResults)
    echo $aantal
}

function doCallMediaHaven {
    aantal=$1
    curl -s -X GET \
    -H "Authorization: Bearer ${token}" \
    -H 'Accept: application/vnd.mediahaven.v2+json' \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/?q=%2B(IngestSpaceId:%22${invoerruimte}%22)%20%2B(IsInIngestSpace%3A1)&nrOfResults=${aantal}" \
    | jq .MediaDataList > "$organisation"_MH.json

    echo "$organisation"_MH.json
}

function createCSVs {
echo $header_database > "$csv_database"
echo $header_download > "$csv_download"
echo $organisation

    aantal=$(getAantal)
    echo $aantal
    aantal=10

    json=$(doCallMediaHaven $aantal)

    for i in $(seq 1 $((aantal-1))) 
    do 
        fragment_id=$(jq -r .[$i].Internal.FragmentId $json)
        extension=$(jq -r .[$i].Technical.OriginalExtension $json)
        filename=$(jq .[$i].Descriptive.OriginalFilename $json)
        filesize=$(jq .[$i].Technical.FileSize $json)
        format=$(getFileType $extension)
        modified=$(jq .[$i].Administrative.LastModifiedDate $json)
        md5=$(jq .[$i].Technical.Md5 $json)
        mime=$(jq .[$i].Technical.MimeType $json)

        echo $fragment_id,$filename,$extension >> "$csv_download"
        echo $filename,$filesize,$modified,$md5,$format,$mime,$server,$organisation >> "$csv_database"
    done
    echo "finished! done done done"
}

## main script
createCSVs