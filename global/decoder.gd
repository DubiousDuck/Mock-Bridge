extends Node

func get_card_from_dict(card_info : Dictionary) -> Card:
	var new_card = Card.new(card_info["point"], card_info["suits"])
	return new_card
	
func get_dict_from_card(card : Card) -> Dictionary:
	return {"point" : card.point, "suits" : card.suits}
	
func encode_deck(deck : CardDeck) -> Array:
	var output = []
	for card : Card in deck.card_list:
		output.append(get_dict_from_card(card))
	return output
	
func decode_deck(code : Array) -> CardDeck:
	var output = CardDeck.new()
	for card_info in code:
		output.add_card_to_deck(get_card_from_dict(card_info))
	return output
