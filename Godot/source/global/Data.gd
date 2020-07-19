extends Node

var monsters := {}


func _ready() -> void:
	_load_pokemons()


func _load_pokemons() -> void:
	monsters.clear()
	
	var file_dicts = Loader.load_dir("res://data/monsters/", ["tres", "res"])
	
	for file_dict in file_dicts:
		monsters[file_dict.data.name] = file_dict.data
	
	print(monsters)
	
