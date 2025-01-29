extends Node2D
var ttl = 6

func _ready():
	$green.emitting = true
	$white.emitting = true
	$red.emitting = true
	$blue.emitting = true
	$yellow.emitting = true

func _process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		queue_free()
