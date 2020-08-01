extends PanelContainer

enum MENU_ITEMS {POKEDEX, POKEMON, BAG, MAP, TRAINER, SAVE, OPTIONS, CLOSE}

var buttonCount := 0
var pos := 0

func _ready():
	buttonCount = find_node("ButtonContainer").get_child_count()
	set_cursor(pos)

func _process(delta):
	if   Input.is_action_just_pressed("menu") or Input.is_action_just_pressed("sprint"):
		close()
	elif Input.is_action_just_pressed("ui_accept"):
		print("PauseMenu: " + find_node("ButtonContainer").get_child(self.pos).name + " pressed")
		find_node("ButtonContainer").get_child(self.pos).emit_signal("pressed")
	elif Input.is_action_just_pressed("ui_up"):
		print("up")
		clear_prev_button()
		pos -= 1
		set_cursor(pos)
	elif Input.is_action_just_pressed("ui_down"):
		print("down")
		clear_prev_button()
		pos += 1
		set_cursor(pos)
	
func close():
	Arceus.emit_signal("pause_menu_close")
	queue_free()

func clear_prev_button():
	find_node("ButtonContainer").get_child(pos).get_child(0).text = ""

func set_cursor(pos: int):
	if (pos < 0):
		pos = self.buttonCount - 1
	if (pos >= self.buttonCount):
		pos = 0
		
	find_node("ButtonContainer").get_child(pos).get_child(0).text = "->"

