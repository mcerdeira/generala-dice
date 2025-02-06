extends Node2D

func _process(delta):
	if visible:
		global_position.x = clamp(get_parent().global_position.x, 217, 1120) 
		if get_parent().global_position.y <= 200:
			global_position.y = get_parent().global_position.y + 116
		else:	
			global_position.y = get_parent().global_position.y - 116
