extends PanelContainer


var buttonCount := 0
var pos := 0

func _ready():
	self.buttonCount = find_node("ButtonContainer").get_child_count()
	self.set_cursor(pos)

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		print("up")
		self.clear_prev_button()
		self.pos -= 1
		self.set_cursor(self.pos)
	elif Input.is_action_just_pressed("ui_down"):
		print("down")
		self.clear_prev_button()
		self.pos += 1
		self.set_cursor(self.pos)
	elif Input.is_action_just_pressed("ui_accept"):
		print("PauseMenu: " + find_node("ButtonContainer").get_child(self.pos).name + " pressed")
		find_node("ButtonContainer").get_child(self.pos).emit_signal("pressed")
		
func clear_prev_button():
	find_node("ButtonContainer").get_child(self.pos).get_child(0).text = ""

func set_cursor(pos: int):
	if (self.pos < 0):
		self.pos = self.buttonCount - 1
	if (self.pos >= self.buttonCount):
		self.pos = 0
		
	find_node("ButtonContainer").get_child(self.pos).get_child(0).text = "->"
