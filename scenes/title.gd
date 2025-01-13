extends Node2D
var started = false
var start_ttl = 3
var resol = 0.4

func _ready():
	Music.play(Global.Temardo)

func _process(delta):
	if started:
		resol = lerp(resol, 0.01, 0.05)
		$ColorRect.material.set_shader_parameter("resolution", resol)
		start_ttl -= 1 * delta
		if start_ttl <= 0:
			get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		if Global.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return

func Start():
	if !started:
		started = true
		Global.play_sound(Global.ScoreSFX)
		await get_tree().create_timer(0.3).timeout
		Global.play_sound(Global.RollSFX)
