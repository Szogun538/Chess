extends Node2D

@export var texture: Texture
@onready var p_parent = get_parent()
@onready var table = p_parent.get_parent()
@onready var original_sprite = $Sprite2D
var dragging = false
var click_radius = 25
var copy = null
var current_tile = null
var start_tile = null
signal b_dragged
signal dropped
signal succsesfull_drop
signal dropping

func _ready() -> void:
	$Sprite2D.texture = texture
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)

func _on_area_entered(other_area):
	current_tile = other_area.get_parent()  # save reference

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and table.turn == p_parent.is_white:
		if (event.position - p_parent.global_position).length() < click_radius and not dragging and event.pressed:
			copy = original_sprite.duplicate()
			copy.modulate.a = 0.5
			dragging = true
			add_child(copy)
			start_tile = current_tile
			emit_signal("b_dragged")
		if dragging and not event.pressed:
			if current_tile != null:
				var allowed = current_tile.accept_drop()
				if not allowed:
					emit_signal("dropping")
					if current_tile.piece_standing == null:
						current_tile.is_occupied = true
						p_parent.global_position = current_tile.position
						current_tile.piece_standing = p_parent
						start_tile.is_occupied = false
					else:
						current_tile.is_occupied = true
						p_parent.global_position = current_tile.position
						current_tile.piece_standing.moves(current_tile.chess_position, 3)
						current_tile.piece_standing.moves(current_tile.chess_position, 5)
						current_tile.piece_standing.queue_free()
						current_tile.piece_standing = p_parent
					start_tile.is_occupied = false
					start_tile.piece_standing = null
					emit_signal("succsesfull_drop")
				else:
					start_tile.is_occupied = true
					p_parent.global_position = start_tile.position
			dragging = false
			remove_child(copy)
			copy = null
			emit_signal("dropped")
	if event is InputEventMouseMotion and dragging:
		p_parent.global_position = event.position 
		copy.position = start_tile.position - p_parent.global_position
func _on_area_exited(other_area):
	pass
