extends Area2D


func _on_control_gui_input(event):
	if event is InputEventMouseButton && event.is_action_pressed("click"):
		$enfasis.visible = !$enfasis.visible
