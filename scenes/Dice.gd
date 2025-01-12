extends Area2D
var velocity = Vector2.ZERO
var angular_velocity = 0.0
var friction = 0.98
var rolling = false
var stoped = false
var launch_angle = deg_to_rad(randi_range(-45, -55))  # Ángulo de lanzamiento fijo
var force_magnitude = randi_range(600, 900)
var initial_force = Vector2.RIGHT.rotated(launch_angle) * force_magnitude
var initial_rotation = randi_range(-10, 10)
var stop = 0
@export var ttl_shot = 0.0
@export var DiceMan : Node2D
var ttl_bounce = 0.3
var dragged = false
var dir = 1
var currentvalue = null
var original_position =  null
var shaking = false
var DiceType = null

func _ready():
	add_to_group("dices")
	original_position = global_position
	
func restart_position():
	global_position = original_position
	
func initialize():
	randomize()
	show_enfasis(false)
	ttl_bounce = 0.5
	dir = 1
	rolling = false
	stoped = false
	stop = Global.pick_random([10, 30, 20, 15])
	# Lanza el dado desde el ángulo fijo (45 grados)
	force_magnitude = randi_range(600, 1800)
	initial_force = Vector2.RIGHT.rotated(launch_angle) * force_magnitude
	initial_rotation = randi_range(-10, 10)
	$SubViewport/Node3D.initialize()
	
func ChangeType(_DiceType):
	DiceType = _DiceType
	$SubViewport/Node3D.ChangeType(DiceType)
	$btn_flip.visible = false
	$btn_copy.visible = false
	
func show_enfasis(value):
	$enfasis.visible = value
	$lbl_add.visible = value
	$lbl_add.text = Global.getDiceExtraText(DiceType, currentvalue)
	shaking = value
	if !shaking:
		rotation_degrees = 0

func throw():
	dir = 1
	throw_dice(initial_force, initial_rotation)

func throw_dice(force: Vector2, rotation_force: float):
	dragged = false
	velocity = force
	angular_velocity = rotation_force
	rolling = true
	stoped = false

func _physics_process(delta):
	if DiceType == Global.DiceTypes.Rubber:
		if rolling:
			$btn_flip.visible = false
	elif DiceType == Global.DiceTypes.Copy:
		if rolling:
			$btn_copy.visible = false
	else:
		$btn_flip.visible = false
		$btn_copy.visible = false
		
	if $btn_flip.visible:
		if abs(global_position.distance_to(get_global_mouse_position())) >=96:
			$btn_flip.visible = false
			
	if $btn_copy.visible:
		if abs(global_position.distance_to(get_global_mouse_position())) >=96:
			$btn_copy.visible = false
	
	if shaking:
		rotation_degrees = randf_range(-4.0, 4.0)
		$lbl_add.rotation_degrees = randf_range(-4.0, 4.0)
		
	what_ami()
	if dragged:
		global_position = get_global_mouse_position()
	elif rolling:
		ttl_shot -= 1 * delta
		if ttl_shot <= 0:
			ttl_bounce -= 1 * delta
			position += velocity * delta
			# Simular fricción
			velocity *= friction
			angular_velocity *= friction

			# Detener el movimiento cuando es muy bajo
			if velocity.length() < stop:
				rolling = false
				stoped = true
			
func what_ami():
	z_index = global_position.y
	currentvalue = $SubViewport/Node3D.what_ami()
	DiceType = $SubViewport/Node3D.what_type()
	$Label.text = str(currentvalue)
	
func _on_area_entered(area):
	if area is Area2D and area.is_in_group("dices") and ttl_bounce <= 0:
		var normal = (position - area.position).normalized()
		dir *= -1
		velocity = velocity.bounce(normal) * -1  # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo
		ttl_bounce = 1

func _on_body_entered(body):
	if body is StaticBody2D:
		var normal = (position - body.position).normalized()
		dir *= -1
		velocity = velocity.bounce(normal) * -1 # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo
		
func _on_control_gui_input(event):
	if !rolling:
		if DiceMan.cant_throw:
			if Global.CopyMode != null:
				if event is InputEventMouseButton && event.is_action_pressed("click"):
					if Global.CopyMode == self:
						Global.CopyMode = null
					else:
						$lbl_copied.visible = true
						$SubViewport/Node3D.broadcast_to(Global.CopyMode)
						Global.CopyMode = null
			else:
				if !dragged:
					if event is InputEventMouseButton && event.is_action_pressed("click"):
						dragged = true
						#get_viewport().set_input_as_handled()
				if dragged:
					if event is InputEventMouseButton && event.is_action_released("click"):
						dragged = false
						
func set_final(target_rotation):
	$SubViewport/Node3D.set_final(target_rotation)

func _on_btn_flip_pressed():
	if DiceType == Global.DiceTypes.Rubber:
		$SubViewport/Node3D.flip(currentvalue)
		local_flip()
		Global.point_list.refresh()

func local_flip():
	if currentvalue == 1:
		currentvalue = 6
	elif currentvalue == 2:
		currentvalue = 5
	elif currentvalue == 3:
		currentvalue = 4
	elif currentvalue == 4:
		currentvalue = 3
	elif currentvalue == 5:
		currentvalue = 2
	elif currentvalue == 6:
		currentvalue = 1

func _on_btn_copy_pressed():
	if DiceType == Global.DiceTypes.Copy:
		Global.CopyMode = self

func _on_control_mouse_entered():
	if Global.CopyMode == null:
		if DiceType == Global.DiceTypes.Rubber:
			if !rolling:
				$btn_flip.visible = true
				print("a")
		elif DiceType == Global.DiceTypes.Copy:
			if !rolling:
				$btn_copy.visible = true
