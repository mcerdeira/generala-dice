extends Control

@onready var selection_rect = $selection_rect
@onready var collision_shape = $selection_area/CollisionShape2D
@onready var rectangle_shape = RectangleShape2D.new()

var start_position: Vector2
var selecting: bool = false

func _ready():
	# Vinculamos el RectangleShape2D al CollisionShape2D
	collision_shape.shape = rectangle_shape
	selection_rect.visible = false
	
func _physics_process(delta):
	if selecting and Global.preventSelect:
		selecting = false

func _input(event: InputEvent):
	if !Global.preventSelect:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				Global.emit(get_global_mouse_position(), 1)
				
				if event.pressed:
					# Inicia el drag
					start_position = _to_local(event.position)
					selection_rect.position = start_position
					selection_rect.size = Vector2.ZERO
					selection_rect.visible = true
					selecting = true
				else:
					# Finaliza el drag
					selection_rect.visible = false
					selecting = false

		elif event is InputEventMouseMotion and selecting:
			# Actualiza el área de selección
			var current_position = _to_local(event.position)
			var size = current_position - start_position
			
			var position_x = start_position.x
			var position_y = start_position.y
			
			if size.x < 0:
				position_x += size.x
			if size.y < 0:
				position_y += size.y
			
			selection_rect.position = Vector2(position_x, position_y)
			selection_rect.size = size.abs()
			rectangle_shape.extents = selection_rect.size / 2
			collision_shape.position = selection_rect.position + selection_rect.size / 2

func _to_local(global_position: Vector2) -> Vector2:
	# Convierte coordenadas globales a locales relativas al Control
	return global_position - get_global_position()

func _on_selection_area_area_entered(area):
	if selecting:
		if area.is_in_group("dices"):
			area.select(true)

func _on_selection_area_area_exited(area):
	if selecting:
		if area.is_in_group("dices"):
			area.select(false)

