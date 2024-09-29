extends HBoxContainer

signal card_chosen(card : Card)

@export var tracking_player : Player

const CARD_UI = preload("res://ui/card_ui.tscn")

var hand_enabled = false

func _process(delta):
	if hand_enabled:
		for control in get_children():
			control.disabled = false
	else:
		for control in get_children():
			control.disabled = true

func clear_hand():
	for card in get_children():
		card.queue_free()

func display_player_hand():
	for card in tracking_player.get_current_hand().get_all_cards():
		var a = CARD_UI.instantiate()
		a.display_card(card)
		a.connect("pressed", card_pressed)
		add_child(a)

func card_pressed():
	for id in range(get_child_count()):
		var card = get_children()[id]
		if card.button_pressed:
			card.button_pressed = false
			print(card.name + " has been chosen.")
			var card_played : Card = tracking_player.get_card_from_hand(id)
			tracking_player.remove_card_from_hand(id)
			emit_signal("card_chosen", card_played)
			card.queue_free()

func toggle_hand(state : bool):
	hand_enabled = state
