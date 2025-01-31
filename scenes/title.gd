extends Node2D
var started = false
var start_ttl = 2.5
var resol = 0.4
var kelvin = 1000
var ThemeSong = null

func _ready():
	Music.play(Global.Temardo)
	ThemeSong = Music._current_track
	Global.init_vars()
	
func _process(delta):
	if started:
		resol = lerp(resol, 0.01, 0.05)
		kelvin =+ 100 * delta
		$ColorRect.material.set_shader_parameter("resolution", resol)
		$ColorRect.material.set_shader_parameter("kelvin", kelvin)
		
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
		$AnimationPlayer.play("new_animation")
		Global.play_sound(Global.ScoreSFX)
		await get_tree().create_timer(0.3).timeout
		Global.play_sound(Global.RollSFX)
