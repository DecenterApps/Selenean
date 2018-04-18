import os
import json
import webbrowser
import urllib.parse
import re


def open_remix(params):
    starting_url = 'https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.22+commit.4cb486ee.js'

    # MacOS
    chrome_path = 'open -a /Applications/Google\ Chrome.app %s'

    # Windows
    # chrome_path = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe %s'

    # Linux
    # chrome_path = '/usr/bin/google-chrome %s'
    
    dic = {'par':json.dumps(params)}
    
    webbrowser.get(chrome_path).open(starting_url+"&"+urllib.parse.urlencode(dic))

def change_imports(data):
    all_matches = re.findall(r"import (.+?);", data)

    for st in all_matches:
        data = data.replace(st, "\"./"+st.rsplit('/', 1)[-1])   

    return data    

def read_file(path):
    with open(path, 'r') as myfile:
        data=myfile.read()

    return change_imports(data)

#--------------------------------------------------------------------------------------------------------

rootdir = './contracts'

arr = []
for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        if (file.endswith(".sol")):
            arr.append({'name':file, 'code':read_file(os.path.join(subdir, file))}) 

open_remix(arr)