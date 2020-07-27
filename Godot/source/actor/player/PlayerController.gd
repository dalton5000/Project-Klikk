extends Node2D
class_name PlayerController

onready var player : Actor = owner

var turn_delay := 0.1
var input_timer := 0.0
var last_input_dir := Vector2.ZERO
var sprint_pressed := false

func _ready():
	
	
	Arceus.connect("dialog_started",self,"on_dialog_start")
	Arceus.connect("dialog_ended",self,"on_dialog_end")
	
func _process(delta: float) -> void:
	
	var input_dir := Vector2.ZERO
	
	if player.state == player.STATES.IDLE:
		if Input.is_action_pressed("ui_left"):			
			input_dir = Vector2.LEFT
		elif Input.is_action_pressed("ui_right"):
			input_dir = Vector2.RIGHT
		elif Input.is_action_pressed("ui_up"):
			input_dir = Vector2.UP
		elif Input.is_action_pressed("ui_down"):
			input_dir = Vector2.DOWN
		
		sprint_pressed = Input.is_action_pressed("sprint")
		
		if input_dir != Vector2.ZERO:
			input_timer += delta
			if input_dir != last_input_dir:
				player.turn(input_dir)
				last_input_dir = input_dir
				input_timer = 0.0
			elif input_timer > turn_delay:
				player.move(input_dir, sprint_pressed)
				
		else:
			last_input_dir = Vector2.ZERO
		
			
		
		if Input.is_action_just_pressed("interact"):
			var cell = Abra.world_to_map(player.position) + player.dir
			if Abra.is_interactable_on_cell(cell):
				Abra.get_interactable_on_cell(cell)._interact()
				
func on_dialog_start():
	player.change_state(player.STATES.WAIT)

func on_dialog_end():
	player.change_state(player.STATES.IDLE)
