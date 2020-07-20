extends Node2D
class_name Actor

signal start_idle
signal start_move

var cell_size : int = Settings.cell_size
var cell_offset : int = cell_size / 2
var move_duration := 0.3 # sec per cell

var map_position : Vector2
var dir : Vector2

var current_anim := "idle"
var next_anim := ""

enum STATES {IDLE, MOVE, WAIT}
var state = STATES.IDLE
var last_state = STATES.IDLE

onready var body_anim = $Animation/BodyAnimation
onready var movement_tween = $MovementTween

func _ready():
	Abra.occupy_position(position)

func move(_dir):
	
	if Abra.is_pos_blocked(position + _dir * cell_size): return
	
	change_state(STATES.MOVE)
	dir = _dir
	
	var anim_suffix : String = get_anim_suffix_from_dir(dir)
	body_anim.play("move" + anim_suffix)
	
	$MovementTween.interpolate_property(self,"position",position,position + dir * cell_size,move_duration,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	$MovementTween.start()
	Abra.free_position(position)
	Abra.occupy_position(position + dir*cell_size)

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
	body_anim.play("stand"+anim_suffix)
	change_state(STATES.IDLE)

func _on_MovementTween_tween_all_completed():
	if state == STATES.MOVE:
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
