extends Button

class_name CardUI

func display_card(card : Card):
	$Name/Points.text = str(card.point)
	$Name/Suits.text = str(card.suits_string)

func display_top_card(deck : CardDeck):
	display_card(deck.get_top_card())
