extends Node2D
var dices = []
var cant_throw = true

func _physics_process(delta):
	if !cant_throw:
		var done = true
		for d in dices:
			if !d.stoped:
				done = false
				break
		
		if done:
			dices = []
			cant_throw = true
			$Beaker.reset()

func arrange():
	var e = 1
	var speeds = [0, 0.1, 0.1, 0.2, 0.3, 0.3]
	for d in dices:
		d.global_position = get_node("Beaker/dicemark" + str(e)).global_position
		d.ttl_shot = speeds[e]
		e += 1

func throw():
	for d in dices:
		d.throw()
	
	cant_throw = false

func add_me(_dice):
	dices.append(_dice)

func remove_me(_dice):
	dices.erase(_dice)
