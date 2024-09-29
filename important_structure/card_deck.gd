extends Resource

class_name CardDeck

@export var card_list : Array[Card]

var name : String

func _init(initial_deck : Array[Card] = [], n = ""):
	card_list = initial_deck
	name = n
	emit_changed()

#Setters
func add_card_to_deck(card : Card):
	card_list.append(card)
	emit_changed()
	
func push_card_to_back(card : Card):
	card_list.push_back(card)
	emit_changed()

func push_card_to_front(card : Card):
	card_list.push_front(card)
	emit_changed()

func remove_card_at_pos(pos):
	card_list.remove_at(pos) #Test this one
	emit_changed()

func shuffle_deck():
	card_list.shuffle()
	emit_changed()

func clear_deck():
	card_list.clear()
	emit_changed()

#Getters

func get_deck_length() -> int:
	return card_list.size()-1

func draw_top_card() -> Card:
	if card_list.size() > 0:
		emit_changed()
		return card_list.pop_front()
	else:
		return null

func get_top_card() -> Card:
	if card_list.size() > 0:
		return card_list.front()
	else:
		return null

func get_card_at_pos(pos : int) -> Card:
	if card_list.size() > pos:
		return card_list[pos]
	else:
		return null

func get_all_cards() -> Array[Card]:
	return card_list
