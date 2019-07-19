# Gebruik API Mediahaven

## Authenticatie

Om de API te kunnen gebruiken moet je een API key hebben. Een API key kan je aanvragen door de string $gebruikersnaam:$paswoord om te zetten naar Base64.

Voorbeeld: De Base64 van nastasia:mijnpassword = bmFzdGFzaWE6bWlqbnBhc3N3b3Jk.

### API key ontvangen

#### Request voor token

```bash
curl -X POST \
    -H 'authorization: Basic $base64($username:$password)' \
    -H 'content-type: application/x-www-form-urlencoded' \
    -d 'grant_type=password' \
    https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/oauth/access_token | jq .
```

#### Voorbeeld response token

```json
{
  "token_type": "Bearer",
  "expires_in": 1800,
  "access_token": "long_string_with_tokens"
}
```

De token kan ook rechtstreeks in een shell variabele gestoken worden door `jq` te gebruiken.

### API key rechtstreeks in shell variabele steken

```bash
TOKEN=$(curl -s -X POST \
    -H 'authorization: Basic $base64($username:$password)' \
    -H 'content-type: application/x-www-form-urlencoded' \
    -d 'grant_type=password' \
    https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/oauth/access_token \
    | jq -r '.access_token')
```

De token blijft dertig minuten geldig.

## Items opvragen in invoerruimte Mediahaven

Met deze call kunnen de metadata van een zelfgekozen aantal resources in de betreffende invoerruimte opgevraagd worden. Als acceptatieformaat wordt een Mediahaven versie van JSON gebruikt. Deze bevat rijkere informatie, zoals de checksum van de bestanden. Die informatie is niet aanwezig in het application/json-formaat.

Het fragment_id van het item heb je nodig om een export te triggeren.

### Request om items op te vragen

```bash
curl -X GET \
    -H "Authorization: Bearer ${TOKEN}" \
    -H 'Accept: application/vnd.mediahaven.v2+json' \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/?q=%2B(IngestSpaceId:%22${INVOERRUIMTE_JOANIE}%22)%20%2B(IsInIngestSpace%3A1)&nrOfResults=${aantal}" \
    | jq .
```

### Example response na het opvragen van items

```json
{
  "TotalNrOfResults": 3222,
  "StartIndex": 0,
  "MediaDataList": [
    {
      "Internal": {
        "MediaObjectId": "hexadecimal_code",
        "FragmentId": "hexadecimal_code",
        "OriginalStatus": "completed",
        "BrowseStatus": "completed",
        "ArchiveStatus": "on_disk",
        "UploadedById": "hexadecimal_code",
        "OrganisationId": "code",
        "IngestSpaceId": "code",
        "IsInIngestSpace": true,
        "IsFragment": false,
        "HasKeyframes": false,
        "ContainsGeoData": false,
        "PathToKeyframe": "https://example.org/file.jpg",
        "PathToKeyframeThumb": "https://example.org/file.jpg",
        "Browses": {
          "Browse": [
            {
              "BaseUrl": "https://example.org",
              "Container": "jpg",
              "FileSize": 0,
              "HasKeyframes": false,
              "Label": "jpg",
              "PathToKeyframe": "browse.jpg",
              "PathToKeyframeThumb": "browse-thumb.jpg"
            }
          ]
        },
        "DepartmentId": null,
        "PathToVideo": null
      },
      "Descriptive": {
        "Title": "filename.jpg",
        "OriginalFilename": "filename.jpg",
        "UploadedBy": "someone",
        "KeyframeStart": 0,
        "RightsOwner": "© hasselt",
        "CreationDate": "2015:10:13 06:57:32",
        "Description": null,
        "Rights": null,
        "Keywords": {
          "Keyword": []
        },
        "Categories": {
          "Category": []
        },
        "Publisher": null,
        "Authors": {},
        "Location": null,
        "Address": {},
        "NonPreferredTerm": null,
        "Publications": null
      },
      "Structural": {
        "FragmentStartFrames": 0,
        "FragmentEndFrames": 0,
        "Sets": {
          "Set": []
        },
        "Collections": {
          "Collection": []
        },
        "Newspapers": {
          "Newspaper": []
        },
        "Relations": {},
        "Fragments": {},
        "FragmentDurationTimeCode": null,
        "FragmentStartTimeCode": null,
        "FragmentEndTimeCode": null,
        "FragmentDurationFrames": null
      },
      "Technical": {
        "OriginalExtension": "jpg",
        "FileSize": 139197969,
        "Md5": "226190d94b21d1b0c7b1a42d855e419d",
        "MimeType": "image/jpeg",
        "Width": 12598,
        "Height": 17820,
        "ImageSize": "12598x17820",
        "ImageQuality": "high",
        "ImageOrientation": "portrait",
        "PronomId": null,
        "VideoTechnical": null,
        "AudioTechnical": null,
        "VideoFormat": null,
        "DurationTimeCode": null,
        "StartTimeCode": null,
        "EndTimeCode": null,
        "DurationFrames": null,
        "StartFrames": null,
        "EndFrames": null,
        "VideoCodec": null,
        "VideoFps": null,
        "VideoBitRate": null,
        "BitRate": null
      },
      "RightsManagement": {
        "Permissions": {
          "Read": [
            "hexadecimal_code"
          ],
          "Write": [
            "$hexadecimal_code"
          ],
          "Export": [
            "hexadecimal_code"
          ]
        },
        "ExpiryDate": null,
        "ExpiryStatus": null
      },
      "Administrative": {
        "OrganisationName": "hasselt",
        "LastModifiedDate": "2015-11-30T11:19:23Z",
        "ArchiveDate": "2015:11:30 12:18:36",
        "Type": "image",
        "IsSynchronized": false,
        "ExternalId": null,
        "DepartmentName": null,
        "Workflow": null,
        "IngestTape": null
      },
      "Context": {
        "IsEditable": true,
        "IsDeletable": true,
        "IsPublic": false,
        "IsExportable": true
      }
    }
  ]
}
```

### Fragment_id opslaan in shell variabele

```bash
FRAGMENT_ID=$(curl -s -X GET \
    -H "Authorization: Bearer ${TOKEN}" \
    -H 'Accept: application/vnd.mediahaven.v2+json' \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/?q=%2B(IngestSpaceId:%22${INVOERRUIMTE_JOANIE}%22)%20%2B(IsInIngestSpace%3A1)&nrOfResults=${aantal}" \
    | jq -r '.MediaDataList[].Internal.FragmentId')
```

## Beelden exporteren uit invoerruimte Mediahavan

Om beelden te exporteren uit Mediahaven moeten een aantal zaken gedaan worden:

1. de id van het exportformaat weten (bv. originele, media size, etc.)
2. een export triggeren
3. via het Job ID de URL van het beeld verkrijgen (als de job klaar is)
4. het beeld via de URL downloaden.

### Exportformaten opvragen

#### Request exportformaten

```bash
curl -X GET \
    -H 'Accept: application/json'
    -H "Authorization: Bearer ${TOKEN}"
    https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/exportlocations \
    | jq .
```

### Response voorbeeldformaten

```json
[
  {
    "id": 151,
    "name": "Large (2400 x 1600)",
    "httpAccessible": true,
    "exportReasonRequired": false,
    "exportReasons": [],
    "customExportReasonAllowed": true
  },
  {
    "id": 152,
    "name": "Medium (800 x 600)",
    "httpAccessible": true,
    "exportReasonRequired": false,
    "exportReasons": [],
    "customExportReasonAllowed": true
  },
  {
    "id": 150,
    "name": "Original",
    "httpAccessible": true,
    "exportReasonRequired": false,
    "exportReasons": [],
    "customExportReasonAllowed": true
  },
  {
    "id": 153,
    "name": "Small (320 x 200)",
    "httpAccessible": true,
    "exportReasonRequired": false,
    "exportReasons": [],
    "customExportReasonAllowed": true
  }
]
```

#### Bewaar id van exportformaat origineel in shell variabele

Net zoals de token kan ook het id van het exportformaat in een shell variabele gestoken worden. Het id voor het exporteren van de originele bestanden werd gekozen (anderen zijn uiteraard ook mogelijk).

```bash
EXPORT_ID=$(curl -s -X GET \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${TOKEN}" \
    https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/exportlocations  \
    | jq -r '.[] | select(.name=="Original") | .id')
```

### Trigger een export

Hiervoor heb je het fragment_id van het gewenste item nodig en de id van het gewenste exportformaat. Het fragment_id kan je halen uit de call voor het opvragen van items in de invoerruimte van Mediahaven.

#### Request om export te triggeren

```bash
curl -X POST \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${TOKEN}" \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/${FRAGMENT_ID}/export/${EXPORT_ID}" \
    | jq .
```

#### Example response wanneer export getriggerd werd

```json
[
  {
    "exportId": "lange_codestring",
    "status": "created",
    "downloadUrl": "",
    "progress": 0
  }
]
```

#### Opnemen van exportId als shell variabele

Uiteraard kan ook deze id opgenomen worden als shell variabele

```bash
JOB_ID=$(curl -X POST \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${TOKEN}" \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/media/${FRAGMENT_ID}/export/${EXPORT_ID}" \
    | jq -r '.[].exportId')
```

### Download het item

Mediahaven moet het exporteren van het item voorbereiden en klaarmaken. Dit kan een tijdje duren. Pas als de afbeelding op een exportlocatie klaar staat, kan het opgevraagd

#### Request om status van export op te vragen

Het export_id uit de call om een export te triggeren kan gebruikt worden om te controleren of het exporteren /voltooid is. In het veld download URL verschijnt er dan een string met de locatie van de afbeelding.

```bash
curl -X GET \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${TOKEN}" \
    "https://hasselt.debeeldbank.be/mediahaven-rest-api/resources/exports/$JOB_ID" \
    | jq .
```

#### Example response van status export

```json
[
  {
    "exportId": "lange_codestring",
    "status": "completed",
    "downloadUrl": "url",
    "progress": 100
  }
]
```

Als de status `completed` is, of de progress `100`, dan verschijnt er een URL om het beeld te downloaden. De download URL's hebben steeds dezelfde syntax: `https://zwevegem.mediahaven.com/index.php/export/download/$JOB_ID`.
