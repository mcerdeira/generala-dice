extends Node2D

func _process(delta):
	if visible:
		global_position.x = clamp(get_parent().global_position.x, 217, 1120) 
		global_position.y = clamp(get_parent().global_position.y - 116, 116, 600)
