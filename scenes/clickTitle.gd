extends Control


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.emit(get_global_mouse_position(), 1)
