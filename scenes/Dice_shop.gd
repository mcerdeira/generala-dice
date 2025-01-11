extends Area2D
@export var lbl_description : RichTextLabel

func _ready():
	add_to_group("diceshop")
	$Label.text = "$" + str($SubViewport/Node3D_shop.price)
	
func unselect():
	$enfasis.visible = false
	
func _on_control_gui_input(event):
	if event is InputEventMouseButton && event.is_action_pressed("click"):
		$enfasis.visible = !$enfasis.visible
		if $enfasis.visible:
			lbl_description.text = "\n" + $SubViewport/Node3D_shop.title + ":\n\n" + $SubViewport/Node3D_shop.description
			var dices = get_tree().get_nodes_in_group("diceshop")
			for d in dices:
				if d != self:
					d.unselect()
		else:
			lbl_description.text = ""
