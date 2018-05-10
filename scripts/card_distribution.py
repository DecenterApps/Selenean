from web3 import Web3, HTTPProvider, IPCProvider
import json
import sys
import texttable as tt

with open('config.json') as data_file:
    config = json.load(data_file)

with open('big.json') as data_file:
	big = json.load(data_file)

command = sys.argv[1]

names = {}
for obj in big["cards"]:
	names[obj["1"]["ID"]] = obj["1"]["title"]
	
# print(names)
# sys.exit()

exclude_addresses = ["0x6c5a25DCb59781BbAf14CEfacE3093e382c29E23", "0xA5Fdb57fEd1DFA68557e88C3Ba3786A9Ca8Fa518", "0xd8E3ec2bD3FC6C02F811dE188B7bF75A206d2CBA", "0xf3FE977d431FA3d723bcB6e4b77f6B1884F7D94C","0x2582EEde06784951E963687bc0bC1361d49f2b8A", "0X6C259EA1FCA0D1883E3FFFDDEB8A0719E1D7265f", "0xA2CC37dEb2C1d171Cf4FAaE2C8b94F64d65e3a83", "0x00158A74921620b39E5c3aFE4dca79feb2c2C143", "0x93cdB0a93Fc36f6a53ED21eCf6305Ab80D06becA"]
exclude_addresses = [a.upper() for a in exclude_addresses]

web3 = Web3(HTTPProvider('https://kovan.decenter.com'))
card_abi = config['cardContract']['abi']
card_address = config['cardContract']['address']
card_contract = web3.eth.contract(card_address, abi=card_abi)

numOfCards = card_contract.call().totalSupply()

if command == "min":
	print("Num of cards: {}".format(numOfCards))
	print("Num of boosters: {}".format(numOfCards/5))
	sys.exit()

mapping = {}
players = []
total_cards = 0
for i in range(0, numOfCards):
	owner = card_contract.call().ownerOf(i).upper()
	if owner in exclude_addresses:
		continue
	
	if owner not in players:
		players.append(owner)

	total_cards += 1
	meta = card_contract.call().metadata(i)[0]
	if names[str(meta)] in mapping:
		mapping[names[str(meta)]] += 1
	else:
		mapping[names[str(meta)]] = 1

result = sorted(mapping.items() , key=lambda t : t[1])

tab = tt.Texttable()
headings = ['Card','Num']
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
print("Total number of cards: {}".format(total_cards))
print("Total number of boosters: {}".format(total_cards/5))
print("------------------------------------------------")
print("Total number of players: {}".format(len(players)))
print(players)