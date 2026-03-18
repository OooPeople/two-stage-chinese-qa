import json
import sys

with open(sys.argv[1], 'r',encoding='utf-8') as f:
    predict_json = json.load(f)
    
with open(sys.argv[2], 'w',encoding='utf-8') as f:
    f.write('id,answer\n')
    for id in predict_json:
        f.write('%s,\"%s\"\n' %(id,predict_json[id]))