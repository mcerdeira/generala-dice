extends Node3D
var price = 0
var DiceType = null

func _ready():
	price = $dice3D.price
	DiceType = $dice3D.DiceType

func ChangeType(_DiceType):
	DiceType = _DiceType
	$dice3D.ChangeType(DiceType)

func getType():
	DiceType = $dice3D.DiceType
	return DiceType
