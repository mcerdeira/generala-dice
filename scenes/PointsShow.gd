extends Node2D
var confeti_obj = preload("res://scenes/Confeti.tscn")
var lococonfeti = false

func _ready():
	Global.PointsShow = self
	visible = false
	
func set_title(title):
	$lbl_points.text = "[center][wave]\n" + title + "[/wave][/center]"
	$lbl_points_calc.text = ""

func showme(_lococonfeti = false):
	lococonfeti = _lococonfeti
	if !Global.BeatTheGame:
		visible = true
	else:
		visible = false
	$Timer.start()
	
func hideme():
	visible = false
	$Timer.stop()

func _on_timer_timeout():
	var h = 220
	var r = 1
	if lococonfeti:
		h = 768
		r = 5
	
	for i in range(r):
		var conf = confeti_obj.instantiate()
		conf.global_position = Vector2(randf_range(0, 1366), randf_range(0, h))
		get_parent().add_child(conf)
