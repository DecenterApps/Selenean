import random
import sys

def _turn(count, curr_cards):
	card_num = 0

	for i in range(0, cards_in_booster):
		num = _getCard(random.randint(0, total))
		
		print("Choosen card: {}".format(num))
		if cards[num] == 0:
			card_num = card_num + 1

		cards[num] += 1

	print("Turn: {}, {}/{}".format(count, curr_cards + card_num, len(rarities)))
	print("--------------------------------------------------------")

	return curr_cards + card_num

def _getCard(randNum):
	right = len(rarities) - 1
	left = 0
	index = 0

	while (left <= right):
		if index == (left+right)/2:
			return index

		index = (left + right) / 2

		if index == 0 or (randNum <= rarities[index] and randNum > rarities[index-1]):
			return index
		if randNum > rarities[index] and randNum < rarities[index+1]:
			return index + 1

		if randNum < rarities[index]:
			right = index-1
		else:
			left = index

# ==============================================================================================================

arr = sys.argv[1].split(',')
cards_in_booster = int(sys.argv[2])
num_of_turns = int(sys.argv[3])

rarities = []
cards = []
curr_cards = 0

for a in range(0, len(arr)):
	if a == 0:
		rarities.append(int(arr[a]))
	else:
		rarities.append(rarities[a-1]+int(arr[a]))

	cards.append(0)

total = rarities[-1]

for b in range(0, num_of_turns):
	curr_cards = _turn(b, curr_cards)
