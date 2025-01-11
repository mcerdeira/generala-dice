extends Node2D
var dices = []
var cant_throw = true

func _ready():
	Global.Temardo = preload("res://music/dados.wav")
	Global.ShakeSFX = preload("res://sfx/shaking.wav")
	Global.RollSFX = preload("res://sfx/roll.wav")
	Global.DiceclickSFX = preload("res://sfx/dice_click.wav")
	Global.ScoreSFX = preload("res://sfx/score.wav")
	Global.ClickSFX = preload("res://sfx/button_click.wav")
	#Music.play(Global.Temardo)
	
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

func arrange():
	var e = 1
	var speeds = [0, 0.1, 0.1, 0.2, 0.3, 0.3]
	for d in dices:
		d.global_position = get_node("Beaker/dicemark" + str(e)).global_position
		d.ttl_shot = speeds[e]
		e += 1
		
func arrange2():
	Global.play_sound(Global.DiceclickSFX)
	var e = 1
	var speeds = [0, 0.1, 0.1, 0.2, 0.3, 0.3]
	var _dices = get_tree().get_nodes_in_group("dices")
	for d in _dices:
		d.global_position = get_node("Beaker/dicemark" + str(e)).global_position
		d.ttl_shot = speeds[e]
		e += 1

func throw():
	for d in dices:
		d.throw()
	
	cant_throw = false

func add_me(_dice):
	dices.append(_dice)

func remove_me(_dice):
	dices.erase(_dice)

func _on_button_2_pressed():
	arrange2()

func clearSelected():
	$pointlist.clearSelected()

func _on_button_3_pressed():
	$Shop.visible = !$Shop.visible
