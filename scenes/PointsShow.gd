extends Node2D
var confeti_obj = preload("res://scenes/Confeti.tscn")

func _ready():
	visible = false

func showme():
	visible = true
	$Timer.start()
	
func hideme():
	visible = false
	$Timer.stop()

func _on_timer_timeout():
	var conf = confeti_obj.instantiate()
	conf.global_position = Vector2(randf_range(0, 1366), randf_range(0, 220))
	get_parent().add_child(conf)
