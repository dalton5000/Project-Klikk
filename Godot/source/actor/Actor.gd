extends Interactable
class_name Actor

enum STATES {IDLE, MOVE, WAIT}

signal start_idle
signal start_move

var cell_size : int = Settings.cell_size
var cell_offset : int = cell_size / 2
var move_duration := 0.3 # sec per cell

var sprint_speed_scale = 2.5

var map_position : Vector2
var dir : Vector2 = Vector2.DOWN

var current_anim := "idle"
var next_anim := ""

var state = STATES.IDLE
var last_state = STATES.IDLE

onready var body_anim: AnimationPlayer = $Animation/BodyAnimation
onready var movement_tween = $MovementTween

func turn(_dir: Vector2): 
	dir = _dir
	var anim_suffix : String = get_anim_suffix_from_dir(dir)
	body_anim.play("stand" + anim_suffix)

func move(_dir: Vector2, sprint := false) -> void:
	
	var speed = sprint_speed_scale if sprint else 1.0
	
	if Abra.is_pos_blocked(position + _dir * cell_size):
		turn(_dir)
		return
		
	dir = _dir
	change_state(STATES.MOVE)
	var anim_suffix : String = get_anim_suffix_from_dir(dir)
	print(speed)
	body_anim.play("move" + anim_suffix, -1, speed, false)
	movement_tween.interpolate_property(self,"position", position,position + dir * cell_size,move_duration / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	movement_tween.start()
	
	Abra.free_position(position)
	Abra.occupy_position(position + dir*cell_size)
	Abra.free_interactable(position)
	Abra.register_interactable(position + dir*cell_size, self)

func change_state(new_state):
	last_state = state
	state = new_state
	match new_state:
		STATES.IDLE:
			emit_signal("start_idle")
		STATES.MOVE:
			emit_signal("start_move")
			
func move_completed():
	var anim_suffix : String = get_anim_suffix_from_dir(dir)
	body_anim.play("stand" + anim_suffix)
	change_state(STATES.IDLE)

func _on_MovementTween_tween_all_completed():
	if state == STATES.MOVE:
		
		if Abra.has_cell_exit(Abra.world_to_map(position)):
			Arceus.emit_signal("stepped_on_exit")
		else:
			move_completed()
			

func get_anim_suffix_from_dir(dir):
	var anim_suffix = ""
	match dir:
		Vector2.UP:
			anim_suffix = "_up"
		Vector2.DOWN:
			anim_suffix = "_down"
		Vector2.LEFT:
			anim_suffix = "_left"
		Vector2.RIGHT:
			anim_suffix = "_right"
	return anim_suffix
