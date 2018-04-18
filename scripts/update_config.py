import os
import json


"""
==============
This script is going to fill config.dist.json file with addresses and abi's from last build. 
This means whenever you do "truffle migrate", you need to run this script and update config file.
==============

==============
To run: $ python update_config.py
==============

"""
directory = "../build/contracts"
dict = {}
abi = {}
for contract in os.listdir(directory):
	if contract.endswith(".json"):
		with open(os.path.join(directory,contract)) as json_contract:
			dictdump = json.loads(json_contract.read())
			if(dictdump["abi"] <> None):
				abi[contract] = dictdump["abi"]
			if(dictdump["networks"].get("42") <> None ):
				#print (contract,dictdump["networks"]["4447"]["address"])
				dict[contract] = dictdump["networks"]["42"]["address"]



for key in dict:
	print (key, dict[key])

with open("config.json","r+") as jsonFile:
	data = json.load(jsonFile)

	cardMetadata = data["metadataContract"]
	decenterCards = data["cardContract"]
	boosterContract = data["boosterContract"]

	data["metadataContract"]["abi"] = abi["CardMetadata.json"]
	data["metadataContract"]["address"] = dict["CardMetadata.json"]

	data["cardContract"]["abi"] = abi["SeleneanCards.json"]
	data["cardContract"]["address"] = dict["SeleneanCards.json"]

	data["boosterContract"]["abi"] = abi["Booster.json"]
	data["boosterContract"]["address"] = dict["Booster.json"]

	jsonFile.seek(0)
	json.dump(data, jsonFile)
	jsonFile.truncate()