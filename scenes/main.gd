extends Node2D
var dices = []

func throw():
	for d in dices:
		d.throw()

func add_me(_dice):
	dices.append(_dice)
