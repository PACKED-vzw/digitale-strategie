LOAD DATA INFILE '/path/to/file.csv' -- change this to location of csv
INTO TABLE digitale_strategie_Hasselt.siegfried
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@filename, filesize, modified, errors, md5, namespace, id, format, version, mime, basis, warning)
SET filename = replace(@filename, '/run/user/1000/gvfs/smb-share:server=atlas.hasselt.local,share=2_11_ctmae$/08_MUS/', ''), 
server = 'U-schijf', organisation = 'Jenevermuseum'; -- change this to name server and museum