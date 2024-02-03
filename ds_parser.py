import pandas as ps 

# function code from https://github.com/shailja-thakur/CodeGen-Fine-Tuning

df_code = ps.DataFrame()

with open('code_segments.json','a') as f:
    for row in df_code['text'].values:
        dic={"text":str(row)}
        ob=ps.json.dumps(dic)
        f.write(ob)
        f.write('\n')
f.close()