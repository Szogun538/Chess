extends Node2D

var is_white = false
@onready var table = get_parent()
var current_position: Vector2

func _ready() -> void:
	$Piece.b_dragged.connect(_on_b_dragged)
	$Piece.dropped.connect(_on_b_dropped)
	$Piece.succsesfull_drop.connect(_on_b_succsesfull_drop)
	moves(current_position, 2)


func _on_b_dragged():
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	var tile_position = $Piece.start_tile.chess_position
	moves(tile_position, 0)

func _on_b_dropped():
	var tile_position = $Piece.start_tile.chess_position
	table.tile_base_on_position(tile_position).check_occ()
	moves(tile_position, 1)

func _on_b_succsesfull_drop():
	table.turn =  not table.turn
	var end_tile_position = $Piece.current_tile.chess_position
	var start_tile_position = $Piece.start_tile.chess_position
	current_position = end_tile_position
	moves(start_tile_position, 3)
	moves(end_tile_position, 2)
	moves(end_tile_position, 1)
	table.tile_base_on_position(current_position).reset_lamps()
	table.tile_base_on_position(start_tile_position).reset_lamps()

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)
# modes: 
#		0 - Showing posibble moves 
#		1 - Hiding options of moves after move
#		2 - Adds self to lamps so king knows where it could go
#		3 - Remove it self from lamps

func moves(posi: Vector2, mode: int):
	var loop_tile = posi
	while loop_tile.y < 7 and loop_tile.x < 7:
		loop_tile += Vector2(1,1)
		if mode <= 2:
			if mode == 0:
				table.change_position_state(loop_tile, table.available(loop_tile, is_white))
			if mode == 1:
				table.tile_base_on_position(loop_tile).check_occ()
			if mode == 2:
				table.tile_base_on_position(loop_tile).add_lamp(self, is_white)
			if table.tile_base_on_position(loop_tile).piece_standing != null:
				break
		if mode == 3:
			table.tile_base_on_position(loop_tile).remove_lamp(self, is_white)
	loop_tile = posi
	while loop_tile.y > 0 and loop_tile.x > 0:
		loop_tile += Vector2(-1,-1)
		if mode <= 2:
			if mode == 0:
				table.change_position_state(loop_tile, table.available(loop_tile, is_white))
			if mode == 1:
				table.tile_base_on_position(loop_tile).check_occ()
			if mode == 2:
				table.tile_base_on_position(loop_tile).add_lamp(self, is_white)
			if table.tile_base_on_position(loop_tile).piece_standing != null:
				break
		if mode == 3:
			table.tile_base_on_position(loop_tile).remove_lamp(self, is_white)
	loop_tile = posi
	while loop_tile.x < 7 and loop_tile.y > 0:
		loop_tile += Vector2(1,-1)
		if mode <= 2:
			if mode == 0:
				table.change_position_state(loop_tile, table.available(loop_tile, is_white))
			if mode == 1:
				table.tile_base_on_position(loop_tile).check_occ()
			if mode == 2:
				table.tile_base_on_position(loop_tile).add_lamp(self, is_white)
			if table.tile_base_on_position(loop_tile).piece_standing != null:
				break
		if mode == 3:
			table.tile_base_on_position(loop_tile).remove_lamp(self, is_white)
	loop_tile = posi
	while loop_tile.x > 0 and loop_tile.y < 7:
		loop_tile += Vector2(-1,1)
		if mode <= 2:
			if mode == 0:
				table.change_position_state(loop_tile, table.available(loop_tile, is_white))
			if mode == 1:
				table.tile_base_on_position(loop_tile).check_occ()
			if mode == 2:
				table.tile_base_on_position(loop_tile).add_lamp(self, is_white)
			if table.tile_base_on_position(loop_tile).piece_standing != null:
				break
		if mode == 3:
			table.tile_base_on_position(loop_tile).remove_lamp(self, is_white)
