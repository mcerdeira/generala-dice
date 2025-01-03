extends Node2D
var shaking = false
@export var DiceMan : Node2D

func reset():
	z_index = -10
	$Label.visible = true
	$Button.text = "AGITAR"
	$sprite.frame = 0
	$sprite.rotation_degrees = 0
	$AnimationPlayer2.play_backwards("new_animation")

func _physics_process(delta):
	$Label.text = str(DiceMan.dices.size())

func _on_button_pressed():
	if DiceMan.dices.size() == 5:
		if !shaking:
			DiceMan.arrange()
			$Button.text = "TIRAR"
			shaking = true
			$Label.visible = false
			$sprite.frame = 1
			z_index = 100
			$AnimationPlayer.play("new_animation")
		else:
			$Button.text = "..."
			shaking = false
			$sprite.frame = 1
			$AnimationPlayer.stop()
			$sprite.rotation_degrees = 45
			DiceMan.throw()
			$AnimationPlayer2.play("new_animation")

func _on_area_2d_area_entered(area):
	if $Button.text == "AGITAR":
		if area.is_in_group("dices"):
			area.initialize()
			DiceMan.add_me(area)

func _on_area_2d_area_exited(area):
	if $Button.text == "AGITAR":
		if area.is_in_group("dices"):
			DiceMan.remove_me(area)
