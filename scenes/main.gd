extends Node2D
var dices = []
var cant_throw = true

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
		$lbl_gameover.visible = true
		$Button2.disabled = true
	else:
		$Button2.disabled = Global.Status != Global.Statuses.IDLE
	
	
	$lbl_goal/lbl_points2.text = str(Global.Goal)
	$lbl_points/lbl_points2.text = str(Global.Points)
	
	$lbl_level/lbl_points2.text = str(Global.Level) + "/" + str(Global.LevelMax)
	$lbl_turn/lbl_points2.text = str(Global.Turn) + "/" + str(Global.TurnMax)
	
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
		await d.move_to(get_node("Beaker/dicemark" + str(e)).global_position).finished
		d.minigrow(_emit)
		if _emit:
			Global.emit(d.global_position, 1)
		d.ttl_shot = speeds[e]
		e += 1
		
func arrange2():
	Global.play_sound(Global.DiceclickSFX)
	var e = 1
	var speeds = [0, 0.1, 0.1, 0.2, 0.3, 0.3]
	var _dices = get_tree().get_nodes_in_group("dices")
	for d in _dices:
		await d.move_to(get_node("Beaker/dicemark" + str(e)).global_position).finished
		d.minigrow()
		Global.emit(d.global_position, 1)
		d.ttl_shot = speeds[e]
		e += 1

func throw():
	for d in dices:
		d.throw()
		d.force_emit()
	
	cant_throw = false

func add_me(_dice):
	dices.append(_dice)

func remove_me(_dice):
	dices.erase(_dice)
	
func force_emit_all():
	var _dices = get_tree().get_nodes_in_group("dices")
	for d in _dices:
		d.minigrow()

func _on_button_2_pressed():
	arrange2()

func clearSelected():
	$pointlist.clearSelected()

func _on_button_3_pressed():
	$Shop.visible = !$Shop.visible
	if visible:
		Music.pitch_to(0.5)

