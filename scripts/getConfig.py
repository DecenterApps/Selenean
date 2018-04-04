import os
import json
import pprint

directory = "../build/contracts"
dict = {}
abi = {}
for contract in os.listdir(directory):
	if contract.endswith(".json"):
		with open(os.path.join(directory,contract)) as json_contract:
			dictdump = json.loads(json_contract.read())
			if(dictdump["abi"] <> None):
				abi[contract] = dictdump["abi"]
			if(dictdump["networks"].get("4447") <> None ):
				#print (contract,dictdump["networks"]["4447"]["address"])
				dict[contract] = dictdump["networks"]["4447"]["address"]



for key in dict:
	print (key, dict[key])

with open("config.dist.json","r+") as jsonFile:
	data = json.load(jsonFile)

	cardMetadata = data["metadataContract"]
	decenterCards = data["cardContract"]
	boosterContract = data["boosterContract"]

	data["metadataContract"]["abi"] = abi["CardMetadata.json"]
	data["metadataContract"]["address"] = dict["CardMetadata.json"]

	data["cardContract"]["abi"] = abi["DecenterCards.json"]
	data["cardContract"]["address"] = dict["DecenterCards.json"]

	data["boosterContract"]["abi"] = abi["Booster.json"]
	data["boosterContract"]["address"] = dict["Booster.json"]

	jsonFile.seek(0)
	json.dump(data, jsonFile)
	jsonFile.truncate()