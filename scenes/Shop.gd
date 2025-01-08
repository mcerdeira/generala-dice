extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_4_pressed():
	visible = !visible


func _on_button_5_pressed():
	pass # Replace with function body.
