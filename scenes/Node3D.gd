extends Node3D
var speed = 2

func _physics_process(delta):
	$MeshInstance3D.rotation.x += speed * delta
	$MeshInstance3D.rotation.z += speed * delta
	$MeshInstance3D.rotation.y += speed * delta 
