extends PanelContainer

var offset := 32
var expanded := false
var expanding := false
var slide_duration = 0.2

onready var slide_tween = $SlideTween
func _ready():
#	offset = rect_size.y
	rect_position.y = -rect_size.y + offset
	slide()

func slide():
	if $SlideTween.is_active(): return
	var target_pos
	if expanded:
		target_pos = -rect_size.y + offset
	else: 
		target_pos = 0
	$SlideTween.interpolate_property(self,"rect_position", rect_position, Vector2(rect_position.x, target_pos), slide_duration,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	$SlideTween.start()
	yield($SlideTween,"tween_all_completed")
	expanded = !expanded


func _on_ShowButton_pressed():
	slide()


func _on_CellInfoButton_pressed():
	Arceus.emit_signal("cell_info_pressed")
