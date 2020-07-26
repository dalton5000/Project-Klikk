extends Sprite
class_name Portal
tool

export var entry = false setget set_entry
export var exit = false setget set_exit
export var entry_id = ""
export var exit_target = ""

export (String, "Up", "Down", "Left", "Right") var entry_view_direction = "Down" setget set_entry_view_direction

func set_entry_view_direction(dir):
	entry_view_direction = dir
	if not is_inside_tree(): return
	
	for child in $Markers.get_children(): child.hide()
	
	var markers = {
	"Left": $Markers/Sprite,
	"Right": $Markers/Sprite2,
	"Up": $Markers/Sprite3,
	"Down": $Markers/Sprite4
	}
	
	markers[dir].show()

func set_entry(e):
	entry = e
	set_color()
	
func set_exit(e):
	exit = e
	set_color()
	
func set_color():
	if entry and exit:
		self_modulate = Color.orange
	elif entry:
		self_modulate = Color.yellow
	elif exit:
		self_modulate = Color.red
	else:
		self_modulate = Color.white

func register_exit():
	Abra.register_exit(position, exit_target)
	
func register_entry():
	var dir := Vector2.ZERO
	match entry_view_direction:
		"Left": dir = Vector2.LEFT
		"Right": dir = Vector2.RIGHT
		"Up": dir = Vector2.UP
		"Down": dir = Vector2.DOWN
		
	Abra.register_entry(position, entry_id, dir)

func _initialize():
	hide()
	if entry: register_entry()
	if exit: register_exit()

func toggle_visibility():
	if visible: hide()
	else: show()
