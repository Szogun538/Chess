extends Node2D

@onready var cs: float = $Sprite2D.scale.x * 5  
@export var scale_speed: float = 0.2
@export var rotation_speed: float = 0.4
@export var movement_speed: float = 200
var central_point:Vector2 = Vector2(-200,-200)
var angle = 0

var pictures = {
	0: preload("res://pictures/Chess_qlt60.png"),
	1: preload("res://pictures/Chess_rlt60.png"),
	2: preload("res://pictures/Chess_nlt60.png"),
	3: preload("res://pictures/Chess_blt60.png"),
	4: preload("res://pictures/Chess_qdt60.png"),
	5: preload("res://pictures/Chess_rdt60.png"),
	6: preload("res://pictures/Chess_ndt60.png"),
	7: preload("res://pictures/Chess_bdt60.png"),
	8: preload("res://pictures/Chess_pdt60.png"),
	9: preload("res://pictures/Chess_plt60.png"),
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = pictures[randi() % 10]
	var rand_scale = (randi() % 100 + 1) * 0.01 + 0.7
	$Sprite2D.scale = Vector2(rand_scale, rand_scale)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle += 10 * delta
	cs -= 1 * delta
	rotation += (rotation_speed * delta * 6) / angle
	$Sprite2D.position.x += movement_speed * delta
	$Sprite2D.position.y += movement_speed * delta
	if $Sprite2D.scale.x > 0 and $Sprite2D.scale.y > 0:
		$Sprite2D.scale.x += -1 * delta * scale_speed
		$Sprite2D.scale.y += -1 * delta * scale_speed
	else:
		self.queue_free()
	var distance = position.distance_to(central_point)
	position += $Sprite2D.transform.x * movement_speed * delta 
	position += $Sprite2D.transform.y * movement_speed * delta 
