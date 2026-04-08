extends Node2D

var is_white = true
@onready var table = get_parent()
var current_position: Vector2

func _ready() -> void:
	$Piece.b_dragged.connect(_on_b_dragged)
	$Piece.dropped.connect(_on_b_dropped)
	$Piece.succsesfull_drop.connect(_on_b_succsesfull_drop)
	moves(current_position, 2)

func _on_b_dragged():
	var tile_position = $Piece.start_tile.chess_position
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	moves(tile_position, 0)

func _on_b_dropped():
	var tile_position = $Piece.start_tile.chess_position
	table.tile_base_on_position(tile_position).check_occ()
	moves(tile_position, 1)

func _on_b_succsesfull_drop():
	table.turn =  not table.turn
	var start_tile_position = $Piece.start_tile.chess_position
	var end_tile_position = $Piece.current_tile.chess_position
	current_position = end_tile_position
	moves(start_tile_position, 3)
	moves(end_tile_position, 2)
	table.tile_base_on_position(start_tile_position).reset_lamps()
	table.tile_base_on_position(current_position).reset_lamps()

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)

# modes: 
#		0 - Showing posibble moves 
#		1 - Hiding options of moves after move
#		2 - Casting light I hope

func moves(posi: Vector2, mode: int):
	var tile_position = posi
	var change_vector
	if tile_position.x > 0 and tile_position.y > 1:
		change_vector = Vector2(tile_position + Vector2(-1, -2))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x < 7 and tile_position.y > 1:
		change_vector = Vector2(tile_position + Vector2(+1, -2))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x > 0 and tile_position.y < 6:
		change_vector = Vector2(tile_position + Vector2(-1, +2))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x < 7 and tile_position.y < 6:
		change_vector = Vector2(tile_position + Vector2(+1, +2))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x > 1 and tile_position.y > 0:
		change_vector = Vector2(tile_position + Vector2(-2, -1))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x > 1 and tile_position.y < 7:
		change_vector = Vector2(tile_position + Vector2(-2, +1))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x < 6 and tile_position.y > 0:
		change_vector = Vector2(tile_position + Vector2(+2, -1))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	if tile_position.x < 6 and tile_position.y < 7:
		change_vector = Vector2(tile_position + Vector2(+2, +1))
		if mode <= 3:
			if mode == 0:
				table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
	
