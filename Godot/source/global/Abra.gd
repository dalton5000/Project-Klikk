extends Node

var cells = {}

enum CELL_TYPE { GROUND, BLOCKED, GRASS_LOW, GRASS_HIGH, WATER, WATER_DEEP}

var cell_data = {
	"type": CELL_TYPE.GROUND,
	"occupied": false,
	"observed": false,
	"interactable": false
}

var occupations = {}

onready var helper_map : TileMap = $HelperMap


func is_cell_blocked(pos):
	if not cells.has(pos):
		return true
	
	if cells[pos].type in [CELL_TYPE.BLOCKED,CELL_TYPE.WATER,CELL_TYPE.WATER_DEEP] or cells[pos].occupied:
		return true
	return false

func is_pos_blocked(pos):
	var c = helper_map.world_to_map(pos)
	var blocked = is_cell_blocked(c)
	return blocked

func occupy_cell(pos):
	if pos in occupations:
		occupations[pos] += 1
	else:
		occupations[pos] = 1
	cells[pos].occupied = true
	
	Arceus.emit_signal("cell_info_updated")
		
func free_cell(pos):
	if pos in occupations:
		occupations[pos] -= 1
	else:
		print("freed non-occupied cell")
	if occupations[pos] < 1:
		cells[pos].occupied = false
		
	Arceus.emit_signal("cell_info_updated")
		
func occupy_position(pos):
	var c = helper_map.world_to_map(pos)
	occupy_cell(c)
	
func free_position(pos):
	var c = helper_map.world_to_map(pos)
	free_cell(c)
	
func register_grass(pos, type):
	cells[pos]["type"] = type
	
func register_interactable(pos, target):
	var c = helper_map.world_to_map(pos)
	cells[c]["interactable"] = target
	
func free_interactable(pos):
	var c = helper_map.world_to_map(pos)
	cells[c]["interactable"] = false
	

func is_interactable_on_cell(c: Vector2):
	if cells[c]["interactable"]: return true
	else: return false
	
func get_interactable_on_cell(c: Vector2) -> Interactable:
	return cells[c]["interactable"]
	
func get_grass_map():
	var grass_map = []
	for cell in cells:
		if cells[cell].type in [CELL_TYPE.GRASS_HIGH, CELL_TYPE.GRASS_LOW]:
			grass_map.append(cell)
	return grass_map

func get_blocked_map():
	var blocked_map = []
	for cell in cells:
		if cells[cell].type in [CELL_TYPE.BLOCKED] or cells[cell].occupied:
			blocked_map.append(cell)
	return blocked_map
	
func init_map(rect):
	unload_map()
	for x in rect.size.x:
		for y in rect.size.y :
			cells[Vector2(x + rect.position.x,y+ rect.position.y)] = cell_data.duplicate(true)

func unload_map():
	cells = {}
	occupations = {}



func world_to_map(pos: Vector2) -> Vector2:
	return helper_map.world_to_map(pos)

func map_to_world(cell: Vector2) -> Vector2:
	return helper_map.map_to_world(cell)
