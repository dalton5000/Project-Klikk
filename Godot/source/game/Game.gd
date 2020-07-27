extends Node2D

onready var world = $World

var player_scene := preload("res://source/actor/player/Player.tscn")
var player : Player
var current_room : Map


func _ready():
	change_room("Testland-intro", "default")
	Arceus.connect("stepped_on_exit",self,"on_stepped_on_exit")
	
func change_room(new_room_id, entry_id):
	unload_current_room() 
	load_new_room(new_room_id)
	current_room.move_cam_to_portal(entry_id)
	
	yield(get_tree().create_timer(0.3), "timeout")
	load_player(entry_id)
	current_room.disable_cam()
	
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
	world.add_child(player)
	player._initialize()
	yield(get_tree(),"idle_frame")
	player.turn(entry["view_direction"])
	
func on_stepped_on_exit():
	var exit = Abra.get_exit_on_cell(Abra.world_to_map(player.position))
	print(exit["room"])
	print(exit["entry"])
	change_room(exit["room"], exit["entry"])
