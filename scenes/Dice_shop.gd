extends Area2D
var price = 0.0
@export var lbl_description : Label

func _ready():
	price = Global.pick_random([5, 6, 10])
	$Label.text = "$" + str(price)
	
func _on_control_gui_input(event):
	if event is InputEventMouseButton && event.is_action_pressed("click"):
		$enfasis.visible = !$enfasis.visible
		if $enfasis.visible:
			lbl_description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
		else:
			lbl_description.text = ""
