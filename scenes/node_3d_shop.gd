extends Node3D
var price = 0
var DiceType = null

func _ready():
	initi()
	
func initi():
	price = $dice3D.price
	DiceType = $dice3D.DiceType
	
func do_scale_speed():
	$dice3D.do_scale_speed()

func randomize_dice():
	$dice3D.randomize_dice()
	initi()

func ChangeType(_DiceType):
	DiceType = _DiceType
	$dice3D.ChangeType(DiceType)

func getType():
	DiceType = $dice3D.DiceType
	return DiceType
