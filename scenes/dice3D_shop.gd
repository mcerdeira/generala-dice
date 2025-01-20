extends MeshInstance3D
var speed = 1.0
var speed_max = 15.0
var x_pos = 0
var y_pos = 0
#var z_pos = 0 
var decided = false
var target_rotation = Vector3.ZERO
var align_speed = 1  # Velocidad de alineación
var DiceType = null
var price = 0
var scale_speed = false

func _ready():
	randomize_dice()
	
func randomize_dice():
	randomize()
	x_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	y_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	#z_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	rotation.x = deg_to_rad(x_pos)
	rotation.y = deg_to_rad(y_pos)
	#rotation.z = deg_to_rad(z_pos)
	initialize()
	if Global.DiceChancesTmp == null or Global.DiceChancesTmp == []:
		Global.refreshPool()
	Global.DiceChancesTmp.shuffle()
	DiceType = Global.DiceChancesTmp.pop_at(0)
	price = DiceType.price
	setTexture()
	
func ChangeType(_DiceType):
	DiceType = _DiceType
	setTexture()
	
func setTexture():
	var material = get_active_material(0)
	var texture = DiceType.texture
	if material and material is StandardMaterial3D:
		material.albedo_texture = texture
	
func initialize():
	decided = false
	speed = 1.0
	align_speed = speed
	
func do_scale_speed():
	scale_speed = true
	
func _physics_process(delta):
	if scale_speed:
		speed = lerp(speed, speed_max, 0.2)
		rotation.x += (speed * delta) 
		rotation.y += (speed * delta)	
	else:	
		rotation.x += (speed * delta) 
		rotation.y += (speed * delta)
		rotation.z += (speed * delta) 
		
func what_ami():
	if !decided:
		return null
	else:
		if x_pos == 0 and y_pos == 0:
			return 1
		if x_pos == 0 and y_pos == 90:
			return 4
		if x_pos == 0 and y_pos == 180:
			return 3	
		if x_pos == 0 and y_pos == 270:
			return 2
		
		if x_pos == 90 and y_pos == 0:
			return 5
		if x_pos == 90 and y_pos == 90:
			return 4
		if x_pos == 90 and y_pos == 180:
			return 6
		if x_pos == 90 and y_pos == 270:
			return 2	
			
		if x_pos == 180 and y_pos == 0:
			return 3
		if x_pos == 180 and y_pos == 90:
			return 4
		if x_pos == 180 and y_pos == 180:
			return 1
		if x_pos == 180 and y_pos == 270:
			return 2
			
		if x_pos == 270 and y_pos == 0:
			return 6
		if x_pos == 270 and y_pos == 90:
			return 4
		if x_pos == 270 and y_pos == 180:
			return 5
		if x_pos == 270 and y_pos == 270:
			return 2
		
			
# Función para alinear a la posición más cercana
func align_to_nearest():
	var curr_rotx = rad_to_deg(rotation.x)
	var curr_roty = rad_to_deg(rotation.y)
	var num_dest = Global.pick_random([1, 2, 3, 4, 5, 6])
	var resu = null
	
	match num_dest:
		1:
			resu = Global.pick_random([
				[0.0, 0.0],
			])
		2:
			resu = Global.pick_random([
				[0.0, 270.0],
				[90.0, 270.0],
				[180.0, 270.0],
				[270.0, 270.0],
			])
		3:
			resu = Global.pick_random([
				[0.0, 180.0],
				[180.0, 0.0],
			])
		4:
			resu = Global.pick_random([
				[0.0, 90.0],
				[90.0, 90.0],
				[180.0, 90.0],
				[270.0, 90.0],
			])
		5:
			resu = Global.pick_random([
				[90.0, 0.0],
				[270.0, 180.0],
			])
		6:
			resu = Global.pick_random([
				[90.0, 180.0],
				[270.0, 0.0],
			])
	
	x_pos = resu[0]
	y_pos = resu[1]
	
	target_rotation.x = deg_to_rad(x_pos)
	target_rotation.y = deg_to_rad(y_pos)
	
	decided = true
