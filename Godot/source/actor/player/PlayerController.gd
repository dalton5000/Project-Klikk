extends Node2D
class_name PlayerController

onready var player : Actor = owner

func _input(event):
	if player.state == player.STATES.IDLE:
		if Input.is_action_pressed("ui_left"):
			player.move(Vector2.LEFT)
		if Input.is_action_pressed("ui_right"):
			player.move(Vector2.RIGHT)
		if Input.is_action_pressed("ui_up"):
			player.move(Vector2.UP)
		if Input.is_action_pressed("ui_down"):
			player.move(Vector2.DOWN)
