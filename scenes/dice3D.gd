extends MeshInstance3D
var speed = 2
var y_pos = 0

func _ready():
	y_pos = Global.pick_random([0.0, 90.0, 180.0, 270.0])
	rotation_degrees.y = y_pos

func _physics_process(delta):
	if get_parent().parent.rolling:
		rotation.x += speed * delta
		rotation.z += speed * delta
		rotation.y += speed * delta 
	if get_parent().parent.stoped:
		rotation_degrees.y = lerp(rotation_degrees.y, y_pos, 0.1)
		rotation_degrees.x = lerp(rotation_degrees.x, 0.0, 0.1)
		rotation_degrees.z = lerp(rotation_degrees.z, 0.0, 0.1)
