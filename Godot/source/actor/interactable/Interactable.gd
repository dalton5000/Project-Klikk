extends Node2D
class_name Interactable

export var interactable_text := ""

func _interact():
	Arceus.emit_signal("dialog_called", [interactable_text])
	
func _initialize():
	Abra.occupy_position(position)
	Abra.register_interactable(position, self)
	
