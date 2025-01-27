extends Node2D
var shaking = false
var shake_time = 0.0
@export var DiceMan : Node2D
var first = true
var trailing = "\n\n"
var shaking_sfx = null
var original_position = null
@export var Mark1 : Marker2D
@export var Mark2 : Marker2D
@export var Mark3 : Marker2D
@export var Mark4 : Marker2D
@export var Mark5 : Marker2D

func _ready():
	Global.Beaker = self
	
func shake(_time):
	shake_time = _time

func reset():
	z_index = -100
	#$Label.visible = true
	$Button.text = "AGITAR" + trailing
	$sprite.frame = 0
	$sprite.rotation_degrees = 0
	$AnimationPlayer2.play_backwards("new_animation")
	$beakerbounce/collider.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	Global.Status = Global.Statuses.IDLE
	Global.point_list.fade_in()
	
func set_original_position():
	original_position = global_position

func _physics_process(delta):
	if shake_time > 0:
		shake_time -= 1 * delta
		global_position.x = original_position.x + randf_range(-3.0, 3.0)
		global_position.y = original_position.y + randf_range(-3.0, 3.0)
		scale.x = 3 + randf_range(-0.1, 0.1)
		scale.y = 3 + randf_range(-0.1, 0.1)
		if shake_time <= 0:
			scale.x = 3
			scale.y = 3
			global_position = original_position
	
	$shadow.frame = $sprite.frame
	$shadow.rotation = $sprite.rotation
	#$Label.text = str(DiceMan.dices.size())
	if Global.GameOver:
		$Button.disabled = true
	else:
		$Button.disabled = (DiceMan.dices.size() >= Global.minforTurn() and Global.Status == Global.Statuses.THROWING)

func _on_button_pressed():
	Global.dices_used = DiceMan.dices.size()
	shake_time = 0.0
	if DiceMan.dices.size() >= Global.minforTurn():
		if !shaking:
			if DiceMan.dices.size() < 5:
				Global.gotoBase(DiceMan.dices, Mark1, Mark2, Mark3, Mark4, Mark5)
				
			Global.uncopyAll() #Quitamos la copia de todos
			#Copiar un dado random si hay dados copiones
			for d in DiceMan.dices:
				d.holohide()
				if d.DiceType == Global.DiceTypes.Copy:
					var dic_cp = Global.getRandomDiceToCopy(d, DiceMan.dices)
					if dic_cp:
						dic_cp.copyMe(d)

			shaking_sfx = Global.play_sound(Global.ShakeSFX)
			DiceMan.clearSelected()
			var dices = get_tree().get_nodes_in_group("dices")
			for d in dices:
				d.show_enfasis(false)
				if d.DiceType == Global.DiceTypes.Fake:
					d.destruir()
				
			for d in DiceMan.dices:
				d.initialize()
				d.visible = false
			
			Global.Status = Global.Statuses.SHAKING
			DiceMan.arrange(false)
			$Button.text = "TIRAR" + trailing
			shaking = true
			#$Label.visible = false
			$sprite.frame = 1
			z_index = 1000
			$AnimationPlayer.play("new_animation")
		else:
			if first:
				first = false
			else:
				Global.Next()
				
			if shaking_sfx:
				shaking_sfx.stop()
				shaking_sfx = null
				
			Global.Status = Global.Statuses.THROWING
			Global.point_list.fade_out()
			$Button.text = "..." + trailing
			shaking = false
			$sprite.frame = 1
			$AnimationPlayer.stop()
			$sprite.rotation_degrees = 45
			DiceMan.throw()
			$AnimationPlayer2.play("new_animation")
			await get_tree().create_timer(0.5).timeout
			Global.play_sound(Global.RollSFX)
			await get_tree().create_timer(0.5).timeout
			$beakerbounce/collider.set_deferred("disabled", false) 

func _on_area_2d_area_entered(area):
	if Global.Status == Global.Statuses.IDLE:
		if area.is_in_group("dices"):
			if area.DiceType == Global.DiceTypes.Fake:
				area.destruir()
			else:
				area.select(false)
				DiceMan.add_me(area)
			
			shake(0.05)

func _on_area_2d_area_exited(area):
	if Global.Status == Global.Statuses.IDLE:
		if area.is_in_group("dices"):
			DiceMan.remove_me(area)
