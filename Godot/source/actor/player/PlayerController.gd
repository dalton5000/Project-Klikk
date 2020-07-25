extends Node2D
class_name PlayerController

onready var player : Actor = owner

func _ready():
	Arceus.connect("dialog_started",self,"on_dialog_start")
	Arceus.connect("dialog_ended",self,"on_dialog_end")
	
func _process(delta: float) -> void:
	if player.state == player.STATES.IDLE:
		if Input.is_action_pressed("ui_left"):
			player.move(Vector2.LEFT)
		elif Input.is_action_pressed("ui_right"):
			player.move(Vector2.RIGHT)
		elif Input.is_action_pressed("ui_up"):
			player.move(Vector2.UP)
		elif Input.is_action_pressed("ui_down"):
			player.move(Vector2.DOWN)
			
		elif Input.is_action_just_pressed("interact"):
			var cell = Abra.world_to_map(player.position) + player.dir
			if Abra.is_interactable_on_cell(cell):
				Abra.get_interactable_on_cell(cell)._interact()

func on_dialog_start():
	player.change_state(player.STATES.WAIT)

func on_dialog_end():
	player.change_state(player.STATES.IDLE)
