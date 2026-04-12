extends Node2D

var is_white = false
@onready var table = get_parent()
var current_position: Vector2
var available_to_move: bool = false
var moved: bool = false
var castling: bool = false

# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Piece.b_dragged.connect(_on_b_dragged)
	$Piece.dropped.connect(_on_b_dropped)
	$Piece.succsesfull_drop.connect(_on_b_succsesfull_drop)
	$Piece.dropping.connect(_on_dropping)
	moves(current_position, 2)

func _process(delta: float) -> void:
	pass

func _on_b_dragged():
	var tile_position = $Piece.start_tile.chess_position
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	moves(tile_position, 0)

func _on_b_dropped():
	var tile_position = $Piece.start_tile.chess_position
	table.tile_base_on_position(tile_position).check_occ()
	moves(tile_position, 1)
	if castling:
		if current_position == Vector2(0,7):
			table.tile_base_on_position(Vector2(0,7)).piece_standing.position = table.tile_base_on_position(Vector2(2,7)).position
			table.tile_base_on_position(Vector2(2,7)).piece_standing = table.tile_base_on_position(Vector2(0,7)).piece_standing
			table.tile_base_on_position(Vector2(0,7)).piece_standing = null
			change_for_castling(Vector2(2,7),current_position)
			castling = false
		if current_position == Vector2(7,7):
			table.tile_base_on_position(Vector2(7,7)).piece_standing.position = table.tile_base_on_position(Vector2(6,7)).position
			table.tile_base_on_position(Vector2(6,7)).piece_standing = table.tile_base_on_position(Vector2(7,7)).piece_standing
			table.tile_base_on_position(Vector2(7,7)).piece_standing = null
			change_for_castling(Vector2(6,7),current_position)
			castling = false

func _on_b_succsesfull_drop():
	table.turn =  not table.turn
	var start_tile_position = $Piece.start_tile.chess_position
	var end_tile_position = $Piece.current_tile.chess_position
	change_for_castling(end_tile_position,start_tile_position)

func change_for_castling(end_pos: Vector2, start_pos: Vector2):
	var end_tile_position = end_pos
	var start_tile_position = start_pos
	current_position = end_tile_position
	if table.piece_checking != null:
		table.piece_checking.reset_attacking()
	moves(start_tile_position, 3)
	moves(end_tile_position, 2)
	reset_check()
	table.tile_base_on_position(start_tile_position).reset_lamps()
	table.tile_base_on_position(current_position).reset_lamps()
	table.reset_attack(not is_white)
	table.tile_base_on_position(start_tile_position).reset_attack()

func on_check():
	$Check.show()
	moves(current_position, 4)
	if available_to_move == false and not table.check_protectors:
		table.game_over = true
	if not table.check_protectors:
		table.check_protectors = true

func _on_dropping():
	var end_tile_position = $Piece.current_tile.chess_position
	if end_tile_position == Vector2(0,7) or end_tile_position == Vector2(2,7):
		table.tile_base_on_position(Vector2(0,7)).piece_standing.position = table.tile_base_on_position(Vector2(3,7)).position
		table.tile_base_on_position(Vector2(3,7)).piece_standing = table.tile_base_on_position(Vector2(0,7)).piece_standing
		table.tile_base_on_position(Vector2(0,7)).piece_standing = null
		table.tile_base_on_position(Vector2(3,7)).piece_standing.change_for_castling(Vector2(3,7), Vector2(0,7))
		castling = true
	if end_tile_position == Vector2(7,7) or end_tile_position == Vector2(6,7):
		table.tile_base_on_position(Vector2(7,7)).piece_standing.position = table.tile_base_on_position(Vector2(5,7)).position
		table.tile_base_on_position(Vector2(5,7)).piece_standing = table.tile_base_on_position(Vector2(7,7)).piece_standing
		table.tile_base_on_position(Vector2(7,7)).piece_standing = null
		table.tile_base_on_position(Vector2(5,7)).piece_standing.change_for_castling(Vector2(5,7), Vector2(7,7))
		castling = true

func reset_check():
	$Check.hide()
	available_to_move = false

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)


func moves(posi: Vector2, mode: int):
	var positions: Array[Vector2] = [Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(1,-1),Vector2(0,-1),Vector2(-1,-1),Vector2(-1,0),Vector2(-1,1)]
	for dir in positions:
		var change_vector = posi + dir
		if dir == positions[0] and posi.y < 7 or dir == positions[1] and posi.y < 7 and posi.x < 7 or dir == positions[2] and posi.x < 7 or dir == positions[3] and posi.y > 0 and posi.x < 7 or dir == positions[4] and posi.y > 0 or dir == positions[5] and posi.x > 0 and posi.y > 0 or dir == positions[6] and posi.x > 0 or dir == positions[7] and posi.x > 0 and posi.y < 7:
			if mode == 0:
				if table.tile_base_on_position(change_vector).white_lamps.size() == 0:
					table.change_position_state(change_vector, table.available(change_vector,is_white))
				elif table.tile_base_on_position(change_vector).check_for_pawn(change_vector,not is_white, true):
					table.change_position_state(change_vector, table.available(change_vector,is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
			if mode == 4:
				if table.tile_base_on_position(change_vector).white_lamps.size() == 0:
					if not (table.available(change_vector,is_white)):
						available_to_move = true
				elif table.tile_base_on_position(change_vector).check_for_pawn(change_vector,not is_white, true):
					if not (table.available(change_vector,is_white)):
						available_to_move = true
	if not moved:
		var directions: Array[Vector2] = [Vector2(1,0),Vector2(-1,0)]
		var p_on_the_way1: bool = false
		var p_on_the_way2: bool = false
		if mode == 0 or mode == 1:
			for dire in directions:
				var loop_pos = posi
				while (loop_pos.x < 6 and dire.x > 0) or (loop_pos.x > 1 and dire.x < 0) :
					loop_pos += dire
					if table.tile_base_on_position(loop_pos).piece_standing != null or table.tile_base_on_position(loop_pos).white_lamps.size() > 0:
						if dire.x > 0:
							p_on_the_way1 = true
						if dire.x < 0: 
							p_on_the_way2 = true
		if table.tile_base_on_position(Vector2(7,7)).piece_standing != null:
			if table.tile_base_on_position(Vector2(7,7)).piece_standing.name == "rook_b7":
				if not table.tile_base_on_position(Vector2(7,7)).piece_standing.moved and not p_on_the_way1:
					if mode == 0:
						table.change_position_state(Vector2(7,7), false)
						table.change_position_state(Vector2(6,7), false)
		if mode == 1:
			table.tile_base_on_position(Vector2(7,7)).check_occ()
			table.tile_base_on_position(Vector2(6,7)).check_occ()
		if table.tile_base_on_position(Vector2(0,7)).piece_standing != null:
			if table.tile_base_on_position(Vector2(0,7)).piece_standing.name == "rook_b0":
				if not table.tile_base_on_position(Vector2(0,7)).piece_standing.moved and not p_on_the_way2:
					if mode == 0:
						table.change_position_state(Vector2(0,7), false)
						table.change_position_state(Vector2(2,7), false)
		if mode == 1:
			table.tile_base_on_position(Vector2(0,7)).check_occ()
			table.tile_base_on_position(Vector2(2,7)).check_occ()
