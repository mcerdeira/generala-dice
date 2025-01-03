extends MeshInstance3D
var speed = 5
var x_pos = 0
var y_pos = 0
#var z_pos = 0 
var decided = false
var target_rotation = Vector3.ZERO
var align_speed = 5  # Velocidad de alineación

func _ready():
	randomize()
	x_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	y_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	#z_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	rotation.x = deg_to_rad(x_pos)
	rotation.y = deg_to_rad(y_pos)
	#rotation.z = deg_to_rad(z_pos)
	initialize()
	
func initialize():
	decided = false
	speed = 10#Global.pick_random([2, 3, 4, 5])
	align_speed = speed
	
func _physics_process(delta):
	if get_parent().parent.rolling:
		rotation.x += (speed * delta) * get_parent().parent.dir
		rotation.y += (speed * delta) * get_parent().parent.dir
		#rotation.z += (speed * delta) * get_parent().parent.dir
	elif get_parent().parent.stoped and !decided:
		align_to_nearest()
		
	# Si ya se decidió el resultado, suavizar hacia la posición objetivo
	if decided:
		rotation.x = lerp_angle(rotation.x, target_rotation.x, align_speed * delta)
		rotation.y = lerp_angle(rotation.y, target_rotation.y, align_speed * delta)
		#rotation.z = lerp_angle(rotation.z, target_rotation.z, align_speed * delta)
		
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
	
	x_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	y_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	#z_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	
	target_rotation.x = deg_to_rad(x_pos)
	target_rotation.y = deg_to_rad(y_pos)
	#target_rotation.z = deg_to_rad(z_pos)
	
	decided = true
