extends Node2D
var shaking = false
@export var DiceMan : Node2D

func reset():
	z_index = -100
	#$Label.visible = true
	$Button.text = "AGITAR\n\n\n"
	$sprite.frame = 0
	$sprite.rotation_degrees = 0
	$AnimationPlayer2.play_backwards("new_animation")
	$beakerbounce/collider.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	Global.Status = Global.Statuses.IDLE
	Global.point_list.fade_in()

func _physics_process(delta):
	$shadow.frame = $sprite.frame
	$shadow.rotation = $sprite.rotation
	#$Label.text = str(DiceMan.dices.size())
	if Global.GameOver:
		$Button.disabled = true
	else:
		$Button.disabled = (DiceMan.dices.size() >= Global.minforTurn() and Global.Status == Global.Statuses.THROWING)

func _on_button_pressed():
	Global.dices_used = DiceMan.dices.size()
	if DiceMan.dices.size() >= Global.minforTurn():
		if !shaking:
			DiceMan.clearSelected()
			var dices = get_tree().get_nodes_in_group("dices")
			for d in dices:
				d.show_enfasis(false)
			
			Global.Status = Global.Statuses.SHAKING
			DiceMan.arrange()
			$Button.text = "TIRAR\n\n\n"
			shaking = true
			#$Label.visible = false
			$sprite.frame = 1
			z_index = 1000
			$AnimationPlayer.play("new_animation")
		else:
			Global.Next()
			Global.Status = Global.Statuses.THROWING
			Global.point_list.fade_out()
			$Button.text = "...\n\n\n"
			shaking = false
			$sprite.frame = 1
			$AnimationPlayer.stop()
			$sprite.rotation_degrees = 45
			DiceMan.throw()
			$AnimationPlayer2.play("new_animation")
			await get_tree().create_timer(1).timeout
			$beakerbounce/collider.set_deferred("disabled", false) 

func _on_area_2d_area_entered(area):
	if Global.Status == Global.Statuses.IDLE:
		if area.is_in_group("dices"):
			area.initialize()
			DiceMan.add_me(area)

func _on_area_2d_area_exited(area):
	if Global.Status == Global.Statuses.IDLE:
		if area.is_in_group("dices"):
			DiceMan.remove_me(area)
