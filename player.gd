extends Node2D

class_name Player

signal hand_changed

var player_name : String
var player_id : int
var current_hand : CardDeck = CardDeck.new([], "Current Hand")
	
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

#Setters
func add_card_to_hand(card):
	current_hand.add_card_to_deck(card)

func remove_card_from_hand(pos):
	current_hand.remove_card_at_pos(pos)

func replace_hand_with(new_hand : CardDeck):
	current_hand = new_hand

#Getters
func get_card_from_hand(pos) -> Card:
	return current_hand.get_card_at_pos(pos)

func get_current_hand() -> CardDeck:
	return current_hand
