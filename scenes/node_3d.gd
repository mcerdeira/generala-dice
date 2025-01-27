extends Node3D
@export var parent : Area2D
var DiceType = null

func initialize():
	$dice3D.initialize()
	
func set_final(target_rotation, _x_pos, _y_pos):
	$dice3D.set_final(target_rotation, _x_pos, _y_pos)
	
func broadcast_to(_dice):
	$dice3D.broadcast_to(_dice)
	
func flip(currentvalue):
	$dice3D.flip(currentvalue)
	
func ChangeType(_DiceType):
	DiceType = _DiceType
	$dice3D.ChangeType(DiceType)

func what_ami():
	return $dice3D.what_ami()

func what_type():
	return $dice3D.DiceType
