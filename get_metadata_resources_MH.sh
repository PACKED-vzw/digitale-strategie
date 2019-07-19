#!/bin/bash

organisation=$1
aantal=$2
server=Mediahaven
header_database=filename,filesize,modified,md5,format,mime,server,organisation
header_download=fragment_id,filename,extension


# idea --> iterate over complex object and save them as seperate json objects
# do then stuff with the json document
# delete then the them json folder
# arithmic with bash variable, e.g. $((aantal-1))


for i in $aantal; do {

}

for json in $(jq -r '.MediaDataList[].Internal')


fragment_id=$(jq '.MediaDataList[].Internal.FragmentId' $json)
extension=$(jq '.MediaDataList[].Technical.OriginalExtension' $json)


filename=$(jq '.MediaDataList[].Descriptive.OriginalFilename' $json)
filesize=$(jq '.MediaDataList[].Technical.FileSize' $json)
modified=(jq '.MediaDataList[].Administrative.LastModifiedDate' $json)
md5=$(jq '.MediaDataList[].Technical.Md5' $json)
mime=$(jq '.MediaDataList[].Technical.MimeType' $json)

