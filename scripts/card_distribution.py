from web3 import Web3, HTTPProvider, IPCProvider
import json
import sys
import texttable as tt

with open('config.json') as data_file:
        config = json.load(data_file)


web3 = Web3(HTTPProvider('https://kovan.decenter.com'))
card_abi = config['cardContract']['abi']
card_address = config['cardContract']['address']
card_contract = web3.eth.contract(card_address, abi=card_abi)

numOfCards = card_contract.call().totalSupply()

mapping = {}
for i in range(0, numOfCards):
	meta = card_contract.call().metadata(i)[0]
	if meta in mapping:
		mapping[meta] += 1
	else:
		mapping[meta] = 1

result = sorted(mapping.items() , key=lambda t : t[1])

tab = tt.Texttable()
headings = ['Id','Num']
tab.header(headings)

ids = []
occurencies = []
for k,v in result:
	ids.append(k)
	occurencies.append(v)

for row in zip(ids,occurencies):
    tab.add_row(row)

s = tab.draw()
print (s)
print("Total number of cards: {}".format(numOfCards))