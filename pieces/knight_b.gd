extends Node2D

var is_white = false
@onready var table = get_parent()
var current_position: Vector2
var type: Move.MoveType
var special: Move.SpecialType = Move.SpecialType.NULL
var promotion_piece: String = ""

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
	check_game_over()

func check_game_over():
	if table.game_over:
		get_tree().change_scene_to_file("res://Main_scenes/main_menu.tscn")

func _on_b_succsesfull_drop():
	table.turn =  not table.turn
	table.change_turn = true
	var end_tile_position = $Piece.current_tile.chess_position
	var start_tile_position = $Piece.start_tile.chess_position
	current_position = end_tile_position
	moves(start_tile_position, 3)
	moves(start_tile_position, 5)
	moves(end_tile_position, 2)
	moves(end_tile_position, 1)
	table.tile_base_on_position(current_position).reset_lamps()
	table.tile_base_on_position(start_tile_position).reset_lamps()
	if table.tile_base_on_position(current_position).path_to_king_from.size() > 0:
		table.tile_base_on_position(current_position).reset_attack()
	if table.tile_base_on_position(current_position).protecting_from.size() > 0:
		table.tile_base_on_position(current_position).reset_attack()
	if table.tile_base_on_position(start_tile_position).path_to_king_from.size() > 0:
		table.tile_base_on_position(start_tile_position).reset_attack()
	moves(end_tile_position, 4)
	add_history(start_tile_position, end_tile_position)

func add_history(start, end):
	if table.tile_base_on_position(current_position).black_lamps.size() != 0:
		if table.tile_base_on_position(current_position).find_brother(self,is_white):
			type = Move.MoveType.MOVE_MULTI
	var move = Move.new(start, end, type, Move.PieceType.N)
	if table.piece_checking != null:
		move.special = Move.SpecialType.CHECK
	move.promotion = promotion_piece
	TurnManager.add(move)

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)

func reset_attacking():
	moves(current_position, 5)
	moves(current_position, 4)

# modes: 
#		0 - Showing posibble moves 
#		1 - Hiding options of moves after move
#		2 - Adds self to lamps so king knows where it could go
#		3 - Remove it self from lamps
#		4 - Adds sekf to path to king
#		5 - Remove it self from path

func moves(posi: Vector2, mode: int):
	var directions: Array[Vector2] = [Vector2(-1,-2), Vector2(1,-2), Vector2(-1,2), Vector2(1,2), Vector2(-2,-1), Vector2(-2,1), Vector2(2,-1), Vector2(2,1)] 
	for dir in directions:
		if dir == Vector2(-1,-2) and posi.x > 0 and posi.y > 1 or dir == Vector2(1,-2) and posi.x < 7 and posi.y > 1 or dir == Vector2(-1,2) and posi.x > 0 and posi.y < 6 or dir == Vector2(1,2) and posi.x < 7 and posi.y < 6 or dir == Vector2(-2,-1) and posi.x > 1 and posi.y > 0 or dir == Vector2(-2,1) and posi.x > 1 and posi.y < 7 or dir == Vector2(2,-1) and posi.x < 6 and posi.y > 0 or dir == Vector2(2,1) and posi.x < 6 and posi.y < 7:
			var change_vector = Vector2(posi + dir)
			if mode == 0:
				if table.tile_base_on_position(posi).protecting_from.size() == 0:
					if table.piece_checking != null:
						if table.tile_base_on_position(change_vector).path_when_pro(table.piece_checking):
							table.change_position_state(change_vector, table.available(change_vector, is_white))
						if table.tile_base_on_position(change_vector).piece_standing == table.piece_checking:
							table.change_position_state(change_vector, table.available(change_vector, is_white))
					else:
						table.change_position_state(change_vector, table.available(change_vector, is_white))
				else:
					if table.tile_base_on_position(change_vector).path_when_pro(table.tile_base_on_position(posi).protecting_from[0]):
						table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
			if mode == 4:
				if table.tile_base_on_position(change_vector).piece_standing != null:
					if table.tile_base_on_position(change_vector).piece_standing.name == "king_w":
						table.piece_checking = self
						if table.tile_base_on_position(current_position).check_for_pawn(current_position, not is_white, true):
							table.check_protectors = false
						table.tile_base_on_position(change_vector).piece_standing.on_check()
			if mode == 5:
				if table.tile_base_on_position(change_vector).piece_standing != null:
					if table.tile_base_on_position(change_vector).piece_standing.name == "king_w":
						table.tile_base_on_position(change_vector).piece_standing.reset_check()
				if table.piece_checking == self:
					table.piece_checking = null

