extends Node2D

@export var texture: Texture
@export var piece: String
var click_radius = 25
var entered = false
var color: Color = Color(0.4,0.4,0.4,0.8)


signal selected

func _draw() -> void:
	draw_circle(Vector2.ZERO, 25, color)

func _ready() -> void:
	queue_redraw()
	$Sprite2D.texture = texture


func _process(delta: float) -> void:
	var dist = global_position.distance_to(get_global_mouse_position())
	if dist < 25:
		if not entered:
			entered = true
			color = Color(0.5,0.5,0.5,0.8) 
			queue_redraw()
	else: 
		if entered:
			entered = false
			color = Color(0.4,0.4,0.4,0.8) 
			queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (get_global_mouse_position() - global_position).length() < click_radius and event.pressed:
			emit_signal("selected")
