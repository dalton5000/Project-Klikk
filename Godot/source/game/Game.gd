extends Node2D

onready var world = $World

enum GAME_STATE {LOADING, MAP, MENU, DIALOG, COMBAT, CUTSCENE}

var state = GAME_STATE.LOADING

var player_scene := preload("res://source/actor/player/Player.tscn")
var player : Player
var current_room : Map


func _ready():
	change_room("Testland-intro", "default")
	Arceus.connect("stepped_on_exit",self,"on_stepped_on_exit")	
	Arceus.connect("dialog_started",self,"on_dialog_start")
	Arceus.connect("dialog_ended",self,"on_dialog_end")
	
func change_game_state(new_state):
	state = new_state
	match new_state:
		GAME_STATE.MENU, GAME_STATE.DIALOG, GAME_STATE.LOADING, GAME_STATE.COMBAT, GAME_STATE.CUTSCENE:
			player.change_state(player.STATES.WAIT)
		GAME_STATE.MAP:
			player.change_state(player.STATES.IDLE)
	
func change_room(new_room_id, entry_id):
	unload_current_room() 
	load_new_room(new_room_id)
	load_player(entry_id)
	
	yield(get_tree().create_timer(0.3), "timeout")
	
func unload_current_room():
	Abra.unload_map()
	for child in world.get_children():
		child.queue_free()

func load_new_room(room_id):
	current_room = load("res://source/rooms/" + room_id + ".tscn").instance()
	world.add_child(current_room)
		
func load_player(entry_id):
	player = player_scene.instance()
	var entry = Abra.get_entry(entry_id)
	var player_pos = Abra.map_to_world( entry["position"] ) + Vector2(8,8)
	player.position = player_pos
	player._initialize()
	world.add_child(player)
	player.turn(entry["view_direction"])


func on_stepped_on_exit():
	var exit = Abra.get_exit_on_cell(Abra.world_to_map(player.position))
	print(exit["room"])
	print(exit["entry"])
	change_room(exit["room"], exit["entry"])

func on_dialog_start():
	change_game_state(GAME_STATE.DIALOG)

func on_dialog_end():
	change_game_state(GAME_STATE.MAP)
