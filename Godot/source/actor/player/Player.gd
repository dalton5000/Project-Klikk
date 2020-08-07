extends Actor
class_name Player

var inventory := {}

func _initialize() -> void:
	._initialize()
	initialize_inventory()

func initialize_inventory():
	for item in Data.items:
		inventory[item] = 5
		
	print("Printing inventory:")
	print(inventory)
