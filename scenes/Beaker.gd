extends Node2D
var shaking = false
var shake_time = 0.0
@export var DiceMan : Node2D
var first = true
var trailing = "\n"
var shaking_sfx = null
var original_position = null
var auto_throw_total = 0.3
var auto_throw = auto_throw_total
@export var Mark1 : Marker2D
@export var Mark2 : Marker2D
@export var Mark3 : Marker2D
@export var Mark4 : Marker2D
@export var Mark5 : Marker2D

func _ready():
	Global.Beaker = self
	Global.Mark1 = Mark1
	Global.Mark2 = Mark2
	Global.Mark3 = Mark3
	Global.Mark4 = Mark4
	Global.Mark5 = Mark5
	
func shake(_time):
	shake_time = _time

func reset():
	z_index = -100
	#$Label.visible = true
	$sprite.frame = 0
	$sprite/beaker_part.frame = $sprite.frame
	$sprite.rotation_degrees = 0
	$AnimationPlayer2.play_backwards("new_animation")
	$beakerbounce/collider.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	Global.Status = Global.Statuses.IDLE
	Global.point_list.fade_in()
	
func set_original_position():
	original_position = global_position

func _physics_process(delta):
	if shaking:
		auto_throw -= 1 * delta
		if auto_throw <= 0:
			botonito(true)
			auto_throw = auto_throw_total
	
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
	$sprite/beaker_part.frame = $sprite.frame
	$shadow.rotation = $sprite.rotation
	#$Label.text = str(DiceMan.dices.size())
	if Global.TurnUsed and Global.LastTurn:
		$Button.disabled = true
	else:
		if Global.GameOver:
			$Button.disabled = true
		else:
			$Button.disabled = (DiceMan.dices.size() >= Global.minforTurn() and Global.Status == Global.Statuses.THROWING)

func _on_button_pressed():
	botonito()
	
func botonito(noclick = false):
	Global.emit(get_global_mouse_position(), 1)
	if !noclick:
		Global.play_sound(Global.ButtonSFX)
	Global.dices_used = DiceMan.dices.size()
	shake_time = 0.0
	if DiceMan.dices.size() >= Global.minforTurn():
		if !shaking:
			auto_throw = auto_throw_total
			
			if Global.TurnUsed:
				Global.point_list.skip()
			
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
			shaking = true
			#$Label.visible = false
			$sprite.frame = 1
			$sprite/beaker_part.frame = $sprite.frame
			z_index = 1000
			$AnimationPlayer.play("new_animation")
		else:
			if first:
				first = false
				
			if shaking_sfx:
				shaking_sfx.stop()
				shaking_sfx = null
				
			Global.TurnUsed = true

			Global.Status = Global.Statuses.THROWING
			Global.point_list.fade_out()
			shaking = false
			$sprite.frame = 1
			$sprite/beaker_part.frame = $sprite.frame
			$AnimationPlayer.stop()
			$sprite.rotation_degrees = 45
			DiceMan.throw()
			await get_tree().create_timer(0.5).timeout
			$AnimationPlayer2.play("new_animation")
			Global.play_sound(Global.RollSFX)
			await get_tree().create_timer(0.5).timeout
			$beakerbounce/collider.set_deferred("disabled", false) 
			
func dice_entered(_dice):
	if Global.Status == Global.Statuses.IDLE or Global.Status == Global.Statuses.WARPING:
		if _dice.is_in_group("dices"):
			if _dice.DiceType == Global.DiceTypes.Fake:
				_dice.destruir()
			else:
				_dice.select(false)
				if _dice not in DiceMan.dices:
					DiceMan.add_me(_dice)
			
			shake(0.05)
				
func _on_area_2d_area_entered(area):
	dice_entered(area)

func _on_area_2d_area_exited(area):
	if Global.Status == Global.Statuses.IDLE:
		if area.is_in_group("dices"):
			DiceMan.remove_me(area)
