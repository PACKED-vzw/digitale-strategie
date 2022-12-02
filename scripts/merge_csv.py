import pandas as pd
import os
from sys import argv

all_dfs = []
folder = argv[1]
path = argv[2]

for file in os.listdir(folder):
    path = folder + '/' + file
    hard_disk = os.path.basename(file).split('.')[0]
    print(hard_disk)
    df = pd.read_excel(path)
    if 'TYPE' in df.columns:
        df = df[df['TYPE'] == 'File']
    df = df[['FILE_PATH', 'NAME', 'SIZE', 'EXT', 'LAST_MODIFIED', 'MD5_HASH', 'PUID', 'MIME_TYPE', 'FORMAT_NAME', 'FORMAT_VERSION']].copy()
    df = df.assign(HARD_DISK=hard_disk)
    df['SIZE'].fillna(0, inplace=True)
    df.fillna('', inplace=True)
    all_dfs.append(df)

all_files_together = pd.concat(all_dfs)
all_files_together.reset_index(drop=True)
all_files_together.to_csv(path, index=False)

