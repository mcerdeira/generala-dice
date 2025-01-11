extends Node3D
@export var parent : Area2D
var DiceType = null

func initialize():
	$dice3D.initialize()
	
func ChangeType(_DiceType):
	DiceType = _DiceType
	$dice3D.ChangeType(DiceType)

func what_ami():
	return $dice3D.what_ami()

func what_type():
	return $dice3D.DiceType
