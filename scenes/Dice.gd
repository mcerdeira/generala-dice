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

func _ready():
	add_to_group("dices")
	
func initialize():
	randomize()
	show_enfasis(false)
	ttl_bounce = 0.3
	dir = 1
	rolling = false
	stoped = false
	stop = Global.pick_random([10, 30, 20, 15])
	# Lanza el dado desde el ángulo fijo (45 grados)
	force_magnitude = randi_range(600, 1800)
	initial_force = Vector2.RIGHT.rotated(launch_angle) * force_magnitude
	initial_rotation = randi_range(-10, 10)
	$SubViewport/Node3D.initialize()
	
func show_enfasis(value):
	$enfasis.visible = value

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
	currentvalue = $SubViewport/Node3D.what_ami()
	$Label.text = str(currentvalue)
				
func _on_area_entered(area):
	if area is Area2D and area.is_in_group("dices") and ttl_bounce <= 0:
		var normal = (position - area.position).normalized()
		dir *= -1
		velocity = velocity.bounce(normal) * -1  # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo

func _on_body_entered(body):
	if body is StaticBody2D:
		var normal = (position - body.position).normalized()
		dir *= -1
		velocity = velocity.bounce(normal) * 0.5 * -1 # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo
		
func _on_input_event(viewport, event, shape_idx):
	if !rolling:
		if DiceMan.cant_throw:
			if !dragged:
				if event is InputEventMouseButton && event.is_action_pressed("click"):
					dragged = true
			if dragged:
				if event is InputEventMouseButton && event.is_action_released("click"):
					dragged = false
