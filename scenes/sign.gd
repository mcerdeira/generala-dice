extends Node2D

func _process(delta):	
	if visible:
		if get_parent().global_position.x >= 217 and get_parent().global_position.x <= 1120:
			global_position.x = get_parent().global_position.x
			 
		if !get_parent().global_position.y >= 116 and !get_parent().global_position.y <= 720:
			global_position.y = get_parent().global_position.y - 116
	else:
		global_position.x = get_parent().global_position.x
		global_position.y = get_parent().global_position.y - 116
