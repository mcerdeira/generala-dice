extends Node2D
var shaking = false
@export var DiceMan : Node2D

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.is_action_released("click"):
		if !shaking:
			shaking = true
			$sprite.frame = 1
			z_index = 100
			$AnimationPlayer.play("new_animation")
		else:
			shaking = false
			$sprite.frame = 1
			$AnimationPlayer.stop()
			$sprite.rotation_degrees = 45
			DiceMan.throw()
