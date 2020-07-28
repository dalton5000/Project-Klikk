extends Actor
class_name Player

var inventory := {}

func _initialize() -> void:
	._initialize()
	print("Printing items:")
	for item in Data.items:
		print(item)
