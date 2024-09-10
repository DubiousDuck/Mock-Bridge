extends Resource

class_name Card

@export var point : int
@export_enum("Spades", "Hearts", "Diamonds", "Clubs") var suits
@export var image : Texture

var card_summary = {}
var name : String
var suits_string : String

func _init(p = 0, s = 0):
	point = p
	suits = s
	match suits:
		0: suits_string = "Spades"
		1: suits_string = "Hearts"
		2: suits_string = "Diamonds"
		3: suits_string = "Clubs"
		_: suits_string = "ERROR"
	obtain_name()
	obtain_image()
	card_summary["point"] = point
	card_summary["suits"] = suits
	

func obtain_name():
	var point_name : String
	match point:
		1: point_name = "Ace"
		2: point_name = "Two"
		3: point_name = "Three"
		4: point_name = "Four"
		5: point_name = "Five"
		6: point_name = "Six"
		7: point_name = "Seven"
		8: point_name = "Eight"
		9: point_name = "Nine"
		10: point_name = "Ten"
		11: point_name = "Jack"
		12: point_name = "Queen"
		13: point_name = "King"
		_: point_name = "ERROR"
	var suits_name : String
	match suits:
		0: suits_name = "Spades"
		1: suits_name = "Hearts"
		2: suits_name = "Diamonds"
		3: suits_name = "Clubs"
		_: suits_name = "ERROR"
	name = point_name + " of " + suits_name

func obtain_image():
	pass
