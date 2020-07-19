extends Node2D

enum DEBUG_BLOCKS {WATER, MISC, GRASS, BLOCKED}

var debug_visible = false

onready var debug_map: TileMap = $Debug
onready var grass_map: TileMap = $Grass

onready var debug_tween: Tween = $DebugTween

func _ready():
	Arceus.connect("cell_info_pressed",self,"toggle_debug_map")
	Arceus.connect("cell_info_updated",self,"update_debug_map")
	
	register_tiles()

func toggle_debug_map():
	if debug_tween.is_active(): return
	if debug_visible:
		debug_tween.interpolate_property(debug_map,"modulate",Color(1, 1, 1, 0.5), Color.transparent,0.3,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	else:
		debug_tween.interpolate_property(debug_map,"modulate",Color.transparent, Color(1, 1, 1, 0.5),0.3,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	debug_tween.start()
	yield(debug_tween,"tween_all_completed")
	debug_visible = !debug_visible
	
func update_debug_map():
	debug_map.clear()
	var g_map = Abra.get_grass_map()
	for cell in g_map:
		debug_map.set_cellv(cell, DEBUG_BLOCKS.GRASS)
	var b_map = Abra.get_blocked_map()
	for cell in b_map:
		debug_map.set_cellv(cell, DEBUG_BLOCKS.BLOCKED)


func register_tiles():
	
	var size = $Ground.get_used_rect()
	Abra.init_map(size)
	
	register_grass()	
	register_blocks()
	update_debug_map()

func register_grass():
	for cell in grass_map.get_used_cells():
		if grass_map.get_cellv(cell) != 0:
			Abra.register_grass(cell, Abra.CELL_TYPE.GRASS_LOW)
		
func register_blocks():
	pass
