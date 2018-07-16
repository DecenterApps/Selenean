from web3 import Web3, HTTPProvider, IPCProvider
import json
import sys
import texttable as tt
import requests

with open('big.json') as data_file:
	big = json.load(data_file)

names = {}
for obj in big["cards"]:
	names[big["cards"][obj]["1"]["ID"]] = big["cards"][obj]["1"]["title"]

r = requests.get('http://138.68.155.82:8088/cards-owned')
all_users = json.loads(r.text)

exclude_addresses = ["0xc5B4cb444F3f02E0618F269c03B18D55F90C33E6", "0x6c5a25DCb59781BbAf14CEfacE3093e382c29E23", "0xA5Fdb57fEd1DFA68557e88C3Ba3786A9Ca8Fa518", "0xd8E3ec2bD3FC6C02F811dE188B7bF75A206d2CBA", "0xf3FE977d431FA3d723bcB6e4b77f6B1884F7D94C","0x2582EEde06784951E963687bc0bC1361d49f2b8A", "0X6C259EA1FCA0D1883E3FFFDDEB8A0719E1D7265f", "0xA2CC37dEb2C1d171Cf4FAaE2C8b94F64d65e3a83", "0x00158A74921620b39E5c3aFE4dca79feb2c2C143", "0x93cdB0a93Fc36f6a53ED21eCf6305Ab80D06becA"]
exclude_addresses = [a.upper() for a in exclude_addresses]


total_cards = 0
all_cards = {}
cards_by_player = {}
for user in all_users:
	#if user['address'].upper() in exclude_addresses:
	#	continue
	user_cards = 0
	count = 0
	for card in user['cards']:
		if card>0:
			user_cards += card
			name = names[str(count)]
			if name in all_cards:
				all_cards[name] += card
			else:
				all_cards[name] = card 
		count += 1

	cards_by_player[user['address']] = user_cards
	total_cards += user_cards 

result = sorted(all_cards.items() , key=lambda t : t[1])

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
print(s)
print("Total number of cards: {}".format(total_cards))
print("Total number of boosters: {}".format(total_cards/5))
print("------------------------------------------------")

result = sorted(cards_by_player.items() , key=lambda t : t[1])

tab = tt.Texttable()
headings = ['Address','Boosters']
tab.header(headings)

addresses = []
bought = []
for k,v in result:
	addresses.append(k)
	bought.append(v / 5)

for row in zip(addresses, bought):
    tab.add_row(row)

s = tab.draw()
print(s)
print("Total number of unique players: {}".format(len(addresses)))
