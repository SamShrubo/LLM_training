import pandas as ps 
import json

# function code from https://github.com/shailja-thakur/CodeGen-Fine-Tuning

df_code = ps.read_csv("dataframe.csv")

with open('code_segments.json','a') as f:
    for row in df_code['text'].values:
        print("Adding row...")
        dic={"text":str(row)}
        ob=json.dumps(dic)
        f.write(ob)
        f.write('\n')
f.close()

