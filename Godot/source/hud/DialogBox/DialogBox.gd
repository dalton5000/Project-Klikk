extends PanelContainer

enum STATES {HIDDEN, TRANSITION, WAITING}

var state = STATES.HIDDEN
var last_state = STATES.HIDDEN

var buffer = []
var buffer_idx = 0
var current_text

onready var label = $Label

signal dialog_start
signal dialog_end

func _ready() -> void:
	hide()
	Arceus.connect("dialog_called", self, "on_dialog_called")
	
func _process(delta: float) -> void:
	if state == STATES.WAITING:
		if Input.is_action_just_pressed("interact"):
			show_next_text()
			
func buffer_dialog(dialog : Array) -> void:
	buffer.append(dialog[0])
	if state == STATES.HIDDEN:
		show_box()

func change_state(new_state : int) -> void:
	last_state = state
	state = new_state	
	match new_state:
		STATES.HIDDEN:
			pass

func show_box():
	show()
	show_next_text()
	Arceus.emit_signal("dialog_started")
			
func hide_box() -> void:
	label.text = ""
	buffer = []
	buffer_idx = 0
	change_state(STATES.HIDDEN)
	hide()
	Arceus.emit_signal("dialog_ended")
	
	
func display_text(text: String) -> void:
	label.text = text
	current_text = text
	#transition here maybe
	change_state(STATES.TRANSITION)
	yield(get_tree().create_timer(0.02), "timeout")
	change_state(STATES.WAITING)

func on_dialog_called(dialog: Array) -> void:
	buffer_dialog(dialog)

func show_next_text() -> void:
	if buffer.size() == 0:
		print("tried to display empty dialog buffer fix this")
		return
	
	if buffer_idx >= buffer.size():
		#end of buffer
		hide_box()
		print("buffer ended")
		return
	
	display_text(buffer[buffer_idx])
	buffer_idx += 1
