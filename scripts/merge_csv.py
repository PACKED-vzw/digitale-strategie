import pandas as pd
import os
from sys import argv

all_dfs = []
folder = argv[1]
path = argv[2]

for file in os.listdir(folder):
    hard_disk = os.path.basename(file).split('.')[0]
    print(hard_disk)
    df = pd.read_ecel(file)
    df.fillna('', inplace=True)
    df = df.assign(hard_disk=hard_disk)
    all_dfs.append(df)

all_files_togheter = pd.concat(all_dfs)
all_files_together.reset_index(drop=True)
all_files_together.to_csv(path, index=False)

