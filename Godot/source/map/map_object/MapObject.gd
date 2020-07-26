extends Node2D

enum TILES {DOOR, BLOCK}

onready var tilemap = $TileMap

func _ready():
	tilemap.hide()
	
func _initialize():
	register_cells()
	
func register_cells():
	for cell in tilemap.get_used_cells():
		match tilemap.get_cellv(cell):
			TILES.BLOCK:
				Abra.occupy_position(tilemap.map_to_world(cell)+position)
			TILES.DOOR:
				#register door
				pass
