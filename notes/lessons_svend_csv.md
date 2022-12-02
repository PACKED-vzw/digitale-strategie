## Lessen van het werken met de Svend csv's

Csv's waren soms te groot om ermee te werken in Google Spreadsheets of LibreOffice. De oplossing was om ze dan te bewerken via Python Pandas.

### Python Scripts

```python
import pandas as pd
file = 'droid.csv'
```

__Neem enkel de gevraagde kolommmen mee__

`data = pd.read_csv(file, low_memory=False, usecols=['FILE_PATH', 'NAME', 'SIZE', 'EXT', 'LAST_MODIFIED', 'MD5_HASH', 'PUID', 'MIME_TYPE', 'FORMAT_NAME', 'FORMAT_VERSION', 'TYPE'])`

__Filter op de bestanden die een File zijn__

Haal met andere woorden de File's weg.

`data = data[data['TYPE'] == 'File']`

__Verwijder de TYPE kolom__

`data = data.drop(['TYPE'], axis=1)`

__Haal de naam van de computer weg uit de file_path__

We willen dus enkel het filepath vanaf de harde schijf. Daarom wordt `media/bcadmin/` verwijderd.

`data['FILE_PATH'] = data['FILE_PATH'].apply(lambda x: str(x)[15:])`

__Schrijf alles weg naar een csv__

`data.to_csv('droid_cleaned.csv', index=False)` 

__Maak van de verschillende csv's 1 die in 1 keer geimporteerd kan worden__

1. loop over de files:

```python

import pandas as pd
import os

all_dfs = []

for file in os.listdir(os.getcwd()):
    hard_disk = os.path.basename(file).split('.')[0]
    print(hard_disk)
    df = pd.read_excel(file, usecols='C, E, H, J, K, M, O, P, Q, R')
    df.fillna('',inplace=True)
    df = df.assign(hard_disk=hard_disk)
    #df
    all_dfs.append(df)

values_together = pd.concat(all_dfs)
values_together.reset_index(drop=True)
values_together.to_csv(path, index=False)
```


2. NaN en None oplossen: https://moonbooks.org/Articles/How-to-replace-NaN-values-in-a-pandas-dataframe-/


### Databank

De csv wordt dan geïmporteerd in de databank. 

__Creëer databank en tabel__

```sql
DROP DATABASE IF EXISTS database_name;

CREATE DATABASE database_name; /* only do this the first time
+ change it to the name you want */

use datbase_name; 

CREATE TABLE table_name( 
    filepath VARCHAR(255),
    filename VARCHAR(255),
    filesize BIGINT,
    extension VARCHAR(50),
    modified VARCHAR(255),
    md5 CHAR(32),
    PUID VARCHAR(10),
    mime VARCHAR(100),
    format VARCHAR(100),
    version VARCHAR(100),
    hard_disk VARCHAR(100),
    PRIMARY KEY (filepath, modified, hard_disk) /* not md5 because of duplicate files. this is also why 
    it's a composite primary key. 
    primary key to prevent accidentally importing the same csv file. */
);
```

__Importeer de data in de databank__

Het is belangrijk dat de csv dezelfde naam heeft als de tabel.

```shell
mysqlimport database_name --user USER -p --fields-terminated-by ',' --fields-enclosed-by '"' --lines-terminated-by '\n' --ignore-lines 1 --ignore table_name.csv
```


