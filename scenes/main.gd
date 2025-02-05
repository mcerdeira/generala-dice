extends Node2D
var dices = []
var cant_throw = true
var dice_obj =  preload("res://scenes/Dice.tscn")

func _ready():
	Global.DiceMan = self

func _physics_process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		if Global.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return
			
	if Global.GameOver:
		if !$lbl_gameover.visible:
			Music.pitch_to(0.2)
		$lbl_gameover.visible = true
		$Button2.disabled = true
		$Button3/cosito.visible = false
		if Global.BeatTheGame:
			$lbl_gameover/lbl_gameover.text = "\n[wave][center]GANASTE![/center][/wave]"
	else:
		$Button2.disabled = Global.Status != Global.Statuses.IDLE
		$Button3.disabled = Global.Status != Global.Statuses.IDLE or Global.TurnUsed
		$Button3/cosito.visible = Global.Points > 0
	
	$lbl_goal/lbl_points2.text = "$" + str(Global.Goal)
	$lbl_points/lbl_points2.text = "$" + str(Global.Points)
	if Global.Points < 0:
		$lbl_points/lbl_points2.set_modulate(Color(1, 0, 0, 1))
	
	if Global.VisualPoints != 0:
		
		$lbl_points/lbl_points3.text = "[wave]\n" + str(abs(Global.VisualPoints)) + "[/wave]"
		$lbl_points/lbl_points4.text = "[wave]" + Global.VisualPointsSign + "[/wave]"
		if Global.VisualPointsSign == "+":
			$lbl_points/lbl_points3.set_modulate(Color(0, 0, 1, 1)) 
			$lbl_points/lbl_points4.set_modulate(Color(0, 0, 1, 1)) 
		else:
			$lbl_points/lbl_points3.set_modulate(Color(1, 0, 0, 1)) 
			$lbl_points/lbl_points4.set_modulate(Color(1, 0, 0, 1)) 
		
	else:
		$lbl_points/lbl_points3.text = ""
		$lbl_points/lbl_points4.text = ""
	
	$lbl_level/lbl_points2.text = str(Global.Level) + "/" + str(Global.LevelMax)
	$lbl_turn/lbl_points2.text = str(min(Global.Turn, Global.TurnMax)) + "/" + str(Global.TurnMax)
	
	if !cant_throw:
		var done = true
		for d in dices:
			if !d.stoped:
				done = false
				break
		
		if done:
			dices = []
			cant_throw = true
			$Beaker.reset()
			
func initial_shake():
	Global.shaker_obj.shake(3, 0.2)

func arrange(_emit = true):
	var e = 1
	var speeds = [0, 0.1, 0.1, 0.2, 0.3, 0.3]
	for d in dices:
		if d.DiceType == Global.DiceTypes.Fake:
			d.destruir()
		else:
			await d.move_to(get_node("Beaker/dicemark" + str(d.id)).global_position).finished
			d.minigrow(_emit)
			d.selected = false
			if _emit:
				Global.emit(d.global_position, 1)
			d.ttl_shot = speeds[e]
			e += 1
		
func arrange2():
	Global.play_sound(Global.DiceclickSFX)
	var e = 1
	var dicem_index = 1
	var speeds = [0, 0.1, 0.1, 0.2, 0.3, 0.3]
	var _dices = get_tree().get_nodes_in_group("dices")
	
	_dices.sort_custom(func(a, b): return a.currentvalue > b.currentvalue)
	
	for d in _dices:
		var move = false
		if d.DiceType == Global.DiceTypes.Fake:
			d.destruir()
		else:
			move_one_dice(d, dicem_index)
			d.ttl_shot = speeds[e]
			e += 1
			dicem_index += 1
				
	Global.Status = Global.Statuses.IDLE
	
func move_one_dice(d, dicem_index):
	await d.move_to(get_node("Beaker/dicemark" + str(dicem_index)).global_position).finished
	d.selected = false
	d.minigrow()
	Global.emit(d.global_position, 1)

func throw():
	for d in dices:
		d.visible = true
		d.throw()
		d.selected = false
		
	cant_throw = false
		
	await get_tree().create_timer(2.1).timeout
	
	var cheeses = 0
	var _dices = get_tree().get_nodes_in_group("dices")
	for d in _dices:
		if d.DiceType == Global.DiceTypes.Cheese:
			cheeses += 1
	
	for i in range(cheeses):
		var extra = dice_obj.instantiate()
		add_me(extra)
		extra.global_position = $Beaker/dicemark1.global_position
		extra.ChangeType(Global.DiceTypes.Fake)
		extra.ttl_shot = 0.1
		extra.initialize()
		extra.DiceMan = self
		add_child(extra)
		extra.add_to_group("dices")
		extra.throw()
		extra.force_emit()

func add_me(_dice):
	dices.append(_dice)

func remove_me(_dice):
	dices.erase(_dice)
	
func force_emit_all():
	var _dices = get_tree().get_nodes_in_group("dices")
	for d in _dices:
		d.minigrow()

func _on_button_2_pressed():
	Global.emit(get_global_mouse_position(), 1)
	Global.Status = Global.Statuses.WARPING
	Global.play_sound(Global.ButtonSFX)
	arrange2()

func clearSelected():
	$pointlist.clearSelected()

func _on_button_3_pressed():
	Global.emit(get_global_mouse_position(), 1)
	Global.play_sound(Global.ButtonSFX)
	$Shop.showme(!$Shop.visible)
	if visible:
		Music.pitch_to(0.5)

func _on_button_pressed():
	Global.emit(get_global_mouse_position(), 1)
	Global.play_sound(Global.ButtonSFX)
	await get_tree().create_timer(0.7).timeout
	Music.pitch_to(1.0)
	get_tree().change_scene_to_file("res://scenes/title.tscn")
