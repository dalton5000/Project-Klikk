extends Node

var monsters := {}
var items : = {}


func _ready() -> void:
	_load_pokemons()
	_load_items()

func _load_pokemons() -> void:
	monsters.clear()
	
	var file_dicts = Loader.load_dir("res://data/monsters/", ["tres", "res"])
	
	for file_dict in file_dicts:
		monsters[file_dict.data.name] = file_dict.data
	
	print(monsters)
	
func _load_items() -> void:
	items.clear()
	
	var file_dicts = Loader.load_dir("res://data/items/", ["tres", "res"])
	for file_dict in file_dicts:
		items[file_dict.data.name] = file_dict.data
		
	print(items)
