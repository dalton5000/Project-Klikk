extends Node2D

var idle_wait_time = 2.0

onready var npc : Actor = owner
var idle_timer : Timer

func _ready():
	if npc.is_strolling:
		npc.connect("start_idle", self, "on_npc_start_idle")
		idle_timer = Timer.new()
		add_child(idle_timer)
		idle_timer.connect("timeout",self,"_on_idle_timer_timeout")
		idle_timer.wait_time=idle_wait_time
		idle_timer.start()
	
func on_npc_start_idle():
	idle_timer.start()

func _on_idle_timer_timeout():
	var next_dir = get_random_dir()
	if npc.state == npc.STATES.IDLE:
		npc.move(next_dir)
		
func get_random_dir():
	var dir : Vector2 = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT][randi() % 4]
	return dir
