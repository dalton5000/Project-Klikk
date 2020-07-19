extends Node

var cells = {}

enum CELL_TYPE { GROUND, BLOCKED, GRASS_LOW, GRASS_HIGH, WATER, WATER_DEEP}

var cell_data = {
	"type": CELL_TYPE.GROUND,
	"occupied": false,
	"observed": false
}

func is_cell_blocked(pos):
	pass

func occupy_cell(pos):
	cells[pos].occupied = true

func register_grass(pos, type):
	cells[pos]["type"] = type

func get_grass_map():
	var grass_map = []
	for cell in cells:
		if cells[cell].type in [CELL_TYPE.GRASS_HIGH, CELL_TYPE.GRASS_LOW]:
			grass_map.append(cell)
	return grass_map

func get_blocked_map():
	var blocked_map = []
	for cell in cells:
		if cell.type in [CELL_TYPE.BLOCKED] or cell.occupied:
			blocked_map.append(cell)
	return blocked_map
	
func init_map(rect):
	unload_map()
	for x in rect.size.x:
		for y in rect.size.y :
			cells[Vector2(x + rect.position.x,y+ rect.position.y)] = cell_data.duplicate(true)

func unload_map():
	cells = {}
