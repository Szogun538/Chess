extends Node2D

var is_white = true
@onready var table = get_parent()
var current_position: Vector2
signal check

# Called when the node enters the scene tree for the first time.
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
	if table.piece_checking != null:
		table.piece_checking.reset_attacking()
	if table.tile_base_on_position(current_position).path_to_king_from.size() > 0:
		table.tile_base_on_position(current_position).reset_attack()
	if table.tile_base_on_position(start_tile_position).path_to_king_from.size() > 0:
		table.tile_base_on_position(start_tile_position).reset_attack()
	moves(end_tile_position, 4)
	table.tile_base_on_position(start_tile_position).reset_lamps()
	table.tile_base_on_position(current_position).reset_lamps()
	if end_tile_position.y == 7:
		self.queue_free()
		return

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)

func reset_attacking():
	moves(current_position, 5)

func moves(posi: Vector2, mode: int):
	var change_vector = posi + Vector2(0,1)
	if mode == 0:
		if table.tile_base_on_position(change_vector).piece_standing == null:
			table.change_position_state(change_vector, table.available(change_vector, is_white))
	if mode == 1:
		table.tile_base_on_position(change_vector).check_occ()
	if posi.x > 0:
		change_vector = posi + Vector2(-1,1)
		if table.tile_base_on_position(change_vector).piece_standing != null:
			if mode == 0:
				if table.tile_base_on_position(posi).protecting_from.size() == 0:
					table.change_position_state(change_vector, table.available(change_vector,is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 4:
				if table.tile_base_on_position(change_vector).piece_standing.name == "king_b":
					table.piece_checking = self
		if mode == 2:
			table.tile_base_on_position(change_vector).add_lamp(self, is_white)
		if mode == 3:
			table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
		if mode == 5 and table.piece_checking != null:
			table.piece_checking = null

	if posi.x < 7:
		change_vector = posi + Vector2(1,1)
		if table.tile_base_on_position(change_vector).piece_standing != null:
			if mode == 0:
				if table.tile_base_on_position(posi).protecting_from.size() == 0:
					table.change_position_state(change_vector, table.available(change_vector,is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 4:
				if table.tile_base_on_position(change_vector).piece_standing.name == "king_b":
					table.piece_checking = self
		if mode == 2:
			table.tile_base_on_position(change_vector).add_lamp(self, is_white)
		if mode == 3:
			table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
		if mode == 5 and table.piece_checking != null:
			table.piece_checking = null

	change_vector = posi + Vector2(0,2)
	if  posi.y == 1:
		if table.tile_base_on_position(posi + Vector2(0,1)).piece_standing == null:
			if table.tile_base_on_position(posi + Vector2(0,2)).piece_standing == null:
				if mode == 0:
					table.change_position_state(change_vector, table.available(change_vector, is_white))
		if mode == 1:
			table.tile_base_on_position(change_vector).check_occ()
