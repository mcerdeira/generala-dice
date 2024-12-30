extends Area2D
var velocity = Vector2.ZERO
var angular_velocity = 0.0
var friction = 0.98
var rolling = true
var launch_angle = deg_to_rad(-45)  # Ángulo de lanzamiento fijo
var force_magnitude = randi_range(400, 600)
var initial_force = Vector2.RIGHT.rotated(launch_angle) * force_magnitude
var initial_rotation = randi_range(-10, 10)
var ttl_bounce = 0.8
var ttl_change_frame_total = 1.1
var ttl_change_frame = 0
@export var DiceMan : Node2D

func _ready():
	add_to_group("dices")
	DiceMan.add_me(self)
	randomize()
	$sprite.rotation_degrees = randf_range(0, 360)
	$sprite.frame = randi() % 6
	# Lanza el dado desde el ángulo fijo (45 grados)
	force_magnitude = randi_range(600, 1800)
	initial_force = Vector2.RIGHT.rotated(launch_angle) * force_magnitude
	initial_rotation = randi_range(-10, 10)

func throw():
	throw_dice(initial_force, initial_rotation)

func throw_dice(force: Vector2, rotation_force: float):
	velocity = force
	angular_velocity = rotation_force
	rolling = true

func _physics_process(delta):
	if rolling:
		$sprite.rotation_degrees += 19 * delta
		ttl_bounce -= 1 * delta
		ttl_change_frame -= 1 * delta
		position += velocity * delta
		rotation += angular_velocity * delta
		if ttl_change_frame <= 0:
			$sprite.frame = randi() % 6
			ttl_change_frame = ttl_change_frame_total
		
		# Simular fricción
		velocity *= friction
		angular_velocity *= friction
		
		# Detener el movimiento cuando es muy bajo
		if velocity.length() < 10:
			rolling = false
			
func _on_area_entered(area):
	if area is Area2D and area.is_in_group("dices") and ttl_bounce <= 0:
		var normal = (position - area.position).normalized()
		velocity = velocity.bounce(normal) * -1  # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo

func _on_body_entered(body):
	if body is StaticBody2D:
		var normal = (position - body.position).normalized()
		velocity = velocity.bounce(normal) * 0.5 * -1 # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo
		
