extends Node2D

const CARD_UI = preload("res://card_ui.tscn")
const PLAYER = preload("res://player.tscn")
const STARTING_CARD_N = 4
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

@onready var main_menu = $MenuCanvasLayer/MainMenu
@onready var address_entry = $MenuCanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var player_hand = $CanvasLayer/PlayerHand
@onready var local_player = $LocalPlayer

var MAIN_DECK : CardDeck = CardDeck.new([], "Main Deck")
var DECK_ON_BOARD : CardDeck = CardDeck.new([], "Deck on Board")
var players = {} #ID for each player

func _ready():
	prepare_deck()
	MAIN_DECK.changed.connect(_on_main_deck_changed)

#Handling Multiplayer
func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	
func add_player(peer_id):
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	player.player_id = peer_id
	players[peer_id] = player
	$PlayerFolder.add_child(player)
	
	update_player_list.rpc_id(peer_id, players)
	initial_deal(peer_id, STARTING_CARD_N)

@rpc("authority", "call_local")
func update_player_list(player_list):
	players = player_list

@rpc("authority", "call_local", "reliable")
func update_hand_to_client(hand_code : Array):
	var new_hand = Decoder.decode_deck(hand_code)
	local_player.replace_hand_with(new_hand)
	player_hand.clear_hand()
	player_hand.display_player_hand()

@rpc("any_peer", "call_local")
func update_hand_to_server(hand_code : Array):
	var new_hand = Decoder.decode_deck(hand_code)
	var target_id = multiplayer.get_remote_sender_id()
	players[target_id].replace_hand_with(new_hand)
	for card in players[target_id].get_current_hand().get_all_cards():
		print(card.name + " is in " + str(target_id) + "'s hand.")

#Main game
func prepare_deck():
	for suit_num in range(0, 4):
		for points in range(1, 14):
			var card : Card = Card.new(points, suit_num)
			MAIN_DECK.add_card_to_deck(card)
	MAIN_DECK.shuffle_deck()
	print("Main deck has " + str(MAIN_DECK.card_list.size()) + " cards.")


func initial_deal(target_id : int, total_num : int):
	var target_player = players[target_id]
	deal_cards_to_player(target_player, total_num)
	var new_code : Array = Decoder.encode_deck(target_player.current_hand)
	update_hand_to_client.rpc_id(target_id, new_code)
	
func deal_cards_to_player(target_player : Player, total_num : int):
	for num in range(total_num):
		var top_card : Card = MAIN_DECK.draw_top_card()
		if top_card != null:
			target_player.add_card_to_hand(top_card)
			print(top_card.name + " has been dealt.")
		else:
			print("There are no more cards to be dealt.")
			break

@rpc("any_peer", "call_local")
func request_deal_cards_to_player(total_num : int):
	if multiplayer.is_server():
		var target_id = multiplayer.get_remote_sender_id()
		var target_player = players[target_id]
		deal_cards_to_player(target_player, total_num)
		var new_code : Array = Decoder.encode_deck(target_player.current_hand)
		update_hand_to_client.rpc_id(target_id, new_code)
	else:
		push_error("This request cannot be sent to a client!")

@rpc("any_peer", "call_local")
func add_card_to_board(code : Dictionary):
	var card : Card = Decoder.get_card_from_dict(code)
	DECK_ON_BOARD.push_card_to_front(card)
	var a = CARD_UI.instantiate()
	a.display_card(card)
	$CanvasLayer/CardStack.add_child(a)
	a.position = Vector2(randf_range(-25, 25), randf_range(-20, 20))
	a.rotation_degrees = randf_range(-70, 70)

func request_add_card_to_board(card : Card):
	pass #maybe this will be useful later

func _on_player_hand_card_chosen(card : Card):
	var dict : Dictionary = Decoder.get_dict_from_card(card)
	add_card_to_board.rpc(dict)
	update_hand_to_server.rpc_id(1, Decoder.encode_deck(local_player.get_current_hand()))

func _on_button_2_pressed():
	request_deal_cards_to_player.rpc_id(1, 4)
	
func _on_button_pressed():
	var top_card : Card = MAIN_DECK.draw_top_card()
	if top_card != null:
		print(top_card.name + " has been drawn")
		add_card_to_board(Decoder.get_dict_from_card(top_card))
	else:
		print("There are no more cards.")

@rpc("any_peer")
func sync_main_deck(deck_code : Array):
	MAIN_DECK = Decoder.decode_deck(deck_code)
	$CanvasLayer/Label.text = "Cards remaining in main deck: " + str(MAIN_DECK.get_deck_length())

func _on_main_deck_changed():
	sync_main_deck.rpc(Decoder.encode_deck(MAIN_DECK))
	$CanvasLayer/Label.text = "Cards remaining in main deck: " + str(MAIN_DECK.get_deck_length())

#Next steps:
#Record and display cards drawn/played v
#Receiving cards and playing cards v
#Multiple player set up v
## Draw from main deck
## each player shld only see their own hand v
#Equally split all cards to four hands
#Turn loops
