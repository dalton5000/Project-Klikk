extends Node2D

onready var world = $World

var player_scene := preload("res://source/actor/player/Player.tscn")
var player : Player

func _ready():
	change_room("Testland-intro", "IntroEntry")
	
func change_room(new_room_id, entry_id):
	unload_current_room() 
	load_new_room(new_room_id)
	
	yield(get_tree().create_timer(0.3), "timeout")
	load_player(entry_id)
	
func unload_current_room():
	Abra.unload_map()
	for child in world.get_children(): child.queue_free()

func load_new_room(room_id):
	var new_room = load("res://source/rooms/" + room_id + ".tscn").instance()
	world.add_child(new_room)
		
func load_player(entry_id):
	player = player_scene.instance()
	var entry = Abra.get_entry("default")
	var player_pos = Abra.map_to_world( entry["position"] ) + Vector2(8,8)
	player.position = player_pos
	world.add_child(player)
	player._initialize()
	yield(get_tree(),"idle_frame")
	player.turn(entry["view_direction"])
