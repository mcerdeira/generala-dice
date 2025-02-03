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
@export var original_position : Marker2D = null
var shaking = false
var DiceType = null
var destiny = null
var copied = false
var selected = false

var rotation_speed : float = 20.0 # Velocidad de la oscilación
var max_rotation : float = 10.0 # Máxima rotación en grados
var _movement_tween : Tween
var _growing_tween : Tween
var current_angle = 0.0
var direction : int = 1 # Dirección de la oscilación (1 o -1)

func move_to(new_position : Vector2, _speed = 0.1) -> Tween:
	#if new_position.is_equal_approx(global_position):
		#return
	
	if _movement_tween:
		_movement_tween.kill()
		
	_movement_tween = create_tween()
	_movement_tween.set_trans(Tween.TRANS_QUINT)
	_movement_tween.set_ease(Tween.EASE_IN_OUT)
	_movement_tween.tween_property(self, "global_position", new_position, _speed)

	return _movement_tween
	
func grow_to(scale :Vector2, _speed = 0.1):
	if _growing_tween:
		_growing_tween.kill()
		
	_growing_tween = create_tween()
	_growing_tween.set_trans(Tween.TRANS_QUINT)
	_growing_tween.set_ease(Tween.EASE_IN_OUT)
	_growing_tween.tween_property(self, "scale", scale, _speed)

	return _growing_tween
	
func disolve():
	var _disolve_tween: Tween
	_disolve_tween = create_tween()
	_disolve_tween.set_trans(Tween.TRANS_QUINT)
	_disolve_tween.set_ease(Tween.EASE_IN_OUT)
	_disolve_tween.tween_property($sprite.material, "shader_parameter/dissolve_value", 0.0, 3.0)

	return _disolve_tween

func _ready():
	add_to_group("dices")
	
func restart_position():
	if DiceType != Global.DiceTypes.Fake:
		await move_to(original_position.global_position, 0.05).finished
	
	minigrow()
	
func force_emit():
	await get_tree().create_timer(0.1).timeout
	Global.emit(global_position, 1)
	
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
	
func agotar():
	$shadow.visible = false
	Global.play_sound(Global.FlameSfx, {}, null, 2.0)
	await disolve().finished
	ChangeType(Global.DiceTypes.Normal)
	$sprite.material.set_shader_parameter("dissolve_value", 1)
	$shadow.visible = true
	
func destruir():
	$shadow.visible = false
	remove_from_group("dices")
	Global.point_list.recalc_forced()
	Global.play_sound(Global.FlameSfx, {}, null, 2.0)
	await disolve().finished
	queue_free()
	
func ChangeType(_DiceType):
	remove_from_group("dices_extra")
	DiceType = _DiceType
	if DiceType == Global.DiceTypes.Hologram:
		add_to_group("dices_extra")
		
	$SubViewport/Node3D.ChangeType(DiceType)
	$btn_flip.visible = false
	
func enfasis_visible():
	return $enfasis.visible
	
func select(val):
	$selected.visible = val
	selected = val

func show_enfasis(value):
	$enfasis.visible = value
	$lbl_add.visible = value
	$lbl_add.text = Global.getDiceExtraText(DiceType, currentvalue)
	
func holohide():
	$holosprite.visible = false

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
	$selected.visible = selected
	if DiceType == Global.DiceTypes.Rubber:
		if rolling:
			$btn_flip.visible = false
	else:
		$btn_flip.visible = false
		
	if $btn_flip.visible:
		if abs(global_position.distance_to(get_global_mouse_position())) >=96:
			$btn_flip.visible = false
			
	if shaking:
		# Calcula el nuevo ángulo usando un movimiento suave
		current_angle += rotation_speed * delta * direction
		
		# Cambia de dirección al alcanzar los límites
		if abs(current_angle) >= max_rotation:
			direction *= -1
		
		# Aplica la rotación al nodo hijo
		rotation_degrees = current_angle
		$lbl_add.rotation_degrees = current_angle
		
	what_ami()
	
	queue_redraw()
	
	if dragged:
		Global.preventSelect = true
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
				minigrow()
				if DiceType == Global.DiceTypes.Hologram:
					$holosprite.visible = true
				
func minigrow(_emit = true):
	if _emit:
		force_emit()
	await grow_to(Vector2(1.3, 1.3)).finished
	grow_to(Vector2(1, 1))
			
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
		position += normal * 5  # Mueve el dado ligeramente fuera del otro
		#ttl_bounce = 100

func _on_body_entered(body):
	if body is StaticBody2D:
		var normal = (position - body.position).normalized()
		dir *= -1
		velocity = velocity.bounce(normal) * -1 # Rebote con pérdida de energía
		angular_velocity *= -0.5  # Invertir la rotación para dar realismo
		
func unCopyMe():
	copied = false
	destiny = null
	$SubViewport/Node3D.broadcast_to(null)
	
func copyMe(_fromdice):
	copied = true
	destiny = _fromdice
	$SubViewport/Node3D.broadcast_to(_fromdice)
		
func _on_control_gui_input(event):
	if !rolling:
		if DiceMan.cant_throw:
			if !dragged:
				if event is InputEventMouseButton && event.is_action_pressed("click"):
					dragged = true
					Global.preventSelect = true
					#get_viewport().set_input_as_handled()
			if dragged:
				if event is InputEventMouseButton && event.is_action_released("click"):
					dragged = false
					Global.preventSelect = false
						
func set_final(target_rotation, _x_pos, _y_pos):
	$SubViewport/Node3D.set_final(target_rotation, _x_pos, _y_pos)

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

func _on_control_mouse_entered():
	if !rolling:
		shaking = true
		Global.emit(get_global_mouse_position(), 1)
		grow_to(Vector2(1.5, 1.5))
	if DiceType == Global.DiceTypes.Rubber:
		if !rolling:
			$btn_flip.visible = true

func _on_control_mouse_exited():
	Global.preventSelect = false
	Global.emit(get_global_mouse_position(), 1)
	grow_to(Vector2(1, 1))
	shaking = false
	rotation_degrees = 0

func _draw():
	if copied and destiny:
		# Convertimos las posiciones globales de origen y destino a locales
		var origin_pos = to_local(global_position)  # Posición del nodo actual
		var destiny_pos = to_local(destiny.global_position)  # Posición de "destiny"
		
		# Variables iniciales
		var xx = origin_pos.x
		var yy = origin_pos.y
		var last_x = xx
		var last_y = yy
		var amount
		var dir
		var segment_length = 10  # Distancia entre segmentos
		var randomness_min = 6   # Mínimo de variación aleatoria
		var randomness_max = 12  # Máximo de variación aleatoria

		# Ángulo inicial desde el origen hacia el destino
		dir = Vector2(xx, yy).angle_to_point(destiny_pos)

		# Calculamos el número de segmentos necesarios
		var distance = Vector2(xx, yy).distance_to(destiny_pos)
		var num_segments = int(distance / segment_length) + 1

		# Dibujamos los segmentos
		for i in range(num_segments):
			# Calculamos la dirección hacia el destino
			dir = Vector2(xx, yy).angle_to_point(destiny_pos)

			# Avanzamos en la dirección del destino
			xx += cos(dir) * segment_length
			yy += sin(dir) * segment_length

			# Aplicamos una variación aleatoria perpendicular
			amount = randomness_min + randf_range(0, randomness_max - randomness_min)
			var perpendicular_dir = dir + PI / 2
			xx += cos(perpendicular_dir) * randf_range(-amount, amount)
			yy += sin(perpendicular_dir) * randf_range(-amount, amount)

			# Dibujamos el segmento
			draw_line(Vector2(last_x, last_y), Vector2(xx, yy), Color8(255, 255, 255), randf_range(0.5, 3.1))

			# Actualizamos la posición del último punto
			last_x = xx
			last_y = yy

		# Conectamos el último segmento directamente al destino
		draw_line(Vector2(last_x, last_y), destiny_pos, Color8(255, 255, 255), 1)

