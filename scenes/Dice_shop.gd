extends Area2D
var selected = false
var DiceType = null
var price = 0
var group = "diceshop"
var available = true
var real_dice = null
@export var current = false
@export var lbl_description : RichTextLabel

func _ready():
	if !current:
		group = "diceshop"
		add_to_group(group)
		initit()
	else:
		group = "diceshopcurrents"
		add_to_group(group)
		
func initit():
	price = $SubViewport/Node3D_shop.price
	$Label.visible = true
	$Label.text = "$" + str($SubViewport/Node3D_shop.price)
	DiceType = $SubViewport/Node3D_shop.DiceType
	if DiceType == Global.DiceTypes.Loaded:
		$sprite.material.set_shader_parameter("shine_speed", 1)
	else:
		$sprite.material.set_shader_parameter("shine_speed", 0)	
		
func randomize_dice():
	$SubViewport/Node3D_shop.randomize_dice()
	initit()
		
func ChangeType(_DiceType, real):
	real_dice = real
	DiceType = _DiceType
	if DiceType == Global.DiceTypes.Loaded:
		$sprite.material.set_shader_parameter("shine_speed", 1)
	$SubViewport/Node3D_shop.ChangeType(DiceType)
	
func unselect():
	selected = false
	$enfasis.visible = false
	
func buy():
	available = false
	$Label.text = "--"
	visible = false
	
func _on_control_gui_input(event):
	if available:
		if event is InputEventMouseButton && event.is_action_pressed("click"):
			$enfasis.visible = !$enfasis.visible
			if $enfasis.visible:
				selected = true
				if !current:
					DiceType = $SubViewport/Node3D_shop.getType()
					
				lbl_description.text = "\n\n" + DiceType.title + ":\n" + DiceType.description
				
				var dices = get_tree().get_nodes_in_group(group)
				for d in dices:
					if d != self:
						d.unselect()
			else:
				unselect()
				lbl_description.text = ""
