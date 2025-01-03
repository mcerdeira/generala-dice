extends Node3D
@export var parent : Area2D

func initialize():
	$dice3D.initialize()

func what_ami():
	return $dice3D.what_ami()
