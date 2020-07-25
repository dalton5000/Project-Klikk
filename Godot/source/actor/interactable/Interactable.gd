extends Node2D
class_name Interactable

export var interactable_text := ""

func _interact():
	Arceus.emit_signal("dialog_called", [interactable_text])
	
func _ready():
	Abra.register_interactable(position, self)
