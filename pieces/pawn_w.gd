extends Node2D

var is_white = true
@onready var table = get_parent()
var current_position: Vector2
var menu: Node2D
var type: Move.MoveType
var special: Move.SpecialType = Move.SpecialType.NULL
var promotion_piece: String = ""

var resp_piece = {
	"queen": preload("res://pieces/queen_w.tscn"),
	"rook": preload("res://pieces/rook_w.tscn"),
	"knight": preload("res://pieces/knight_w.tscn"),
	"bishop": preload("res://pieces/bishop_w.tscn"),
	}

var promotion_menu = preload("res://SubScenesForGameplay/Promotion/promotion.tscn")

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
	if table.game_over:
		TurnManager.history[TurnManager.history.size() -1].special = Move.SpecialType.CHECKMATE
		get_tree().change_scene_to_file("res://Main_scenes/main_menu.tscn")

func _on_b_succsesfull_drop():
	table.first_moved = true
	var end_tile_position = $Piece.current_tile.chess_position
	var start_tile_position = $Piece.start_tile.chess_position
	current_position = end_tile_position
	if current_position.y == 7:
		if table.tile_base_on_position(start_tile_position).path_to_king_from.size() > 0:
			table.tile_base_on_position(start_tile_position).reset_attack()
		table.tile_base_on_position(start_tile_position).reset_lamps()
		moves(start_tile_position, 3)
		moves(start_tile_position, 5)
		promotion()
		return
	en_passant(start_tile_position,end_tile_position)
	table.turn =  not table.turn
	table.change_turn = true
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
	var move = Move.new(start, end, type, Move.PieceType.P)
	if table.piece_checking != null:
		move.special = Move.SpecialType.CHECK
	move.promotion = promotion_piece
	TurnManager.add(move)

func promotion():
	$Piece/Sprite2D.hide()
	menu = promotion_menu.instantiate()
	menu.select.connect(_on_selection)
	menu.is_white = is_white
	add_child(menu)

func _on_selection():
	var resp = resp_piece[menu.selected_piece].instantiate()
	resp.position = position
	resp.current_position = current_position
	table.add_child(resp)
	table.tile_base_on_position(current_position).piece_standing = resp
	resp.moves(current_position,2)
	resp.moves(current_position,4)
	resp.check_game_over()
	promotion_piece = menu.selected_piece
	add_history($Piece.start_tile.chess_position, current_position)
	table.turn =  not table.turn
	table.change_turn = true
	self.queue_free()

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)

func reset_attacking():
	moves(current_position, 5)

func en_passant(start: Vector2, end: Vector2):
	if start - end == Vector2(1,-1) and type != Move.MoveType.KILL:
		type = Move.MoveType.EP
		var dead_position: Vector2 = end + Vector2(0,-1)
		var tile_to_reset: Node2D = table.tile_base_on_position(dead_position)
		var dead_pawn: Node2D = tile_to_reset.piece_standing
		dead_pawn.moves(dead_position, 3)
		dead_pawn.moves(dead_position, 5)
		tile_to_reset.piece_standing = null
		dead_pawn.queue_free()
		tile_to_reset.reset_lamps()
		tile_to_reset.reset_attack()
	elif start - end == Vector2(-1,-1) and type != Move.MoveType.KILL:
		type = Move.MoveType.EP
		var dead_position: Vector2 = end + Vector2(0,-1)
		var tile_to_reset: Node2D = table.tile_base_on_position(dead_position)
		var dead_pawn: Node2D = tile_to_reset.piece_standing
		dead_pawn.moves(dead_position, 3)
		dead_pawn.moves(dead_position, 5)
		tile_to_reset.piece_standing = null
		dead_pawn.queue_free()
		tile_to_reset.reset_lamps()
		tile_to_reset.reset_attack()
	

# modes: 
#		0 - Showing posibble moves 
#		1 - Hiding options of moves after move
#		2 - Adds self to lamps so king knows where it could go
#		3 - Remove it self from lamps
#		4 - Adds sekf to path to king
#		5 - Remove it self from path

func moves(posi: Vector2, mode: int):
	var change_vector = posi + Vector2(0,1)
	if mode == 0:
		if table.tile_base_on_position(change_vector).piece_standing == null:
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
	if posi.x > 0:
		change_vector = posi + Vector2(-1,1)
		if table.tile_base_on_position(change_vector).piece_standing != null:
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
					if table.tile_base_on_position(change_vector).piece_standing == table.tile_base_on_position(posi).protecting_from[0]:
						table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 4:
				if table.tile_base_on_position(change_vector).piece_standing.name == "king_b":
					table.piece_checking = self
					for piece in table.tile_base_on_position(posi).black_lamps:
						if piece.name.left(6) != "king_b":
							if piece.name.left(6) == "pawn_b":
								if piece.current_position - posi == Vector2(-1,1) or piece.current_position - posi == Vector2(-1,1):
									table.check_protectors = true
									break
								else:
									table.check_protectors = false
							else:
								table.check_protectors = true
								break
						else:
							table.check_protectors = false
					table.tile_base_on_position(change_vector).piece_standing.on_check()
		if mode == 2:
			table.tile_base_on_position(change_vector).add_lamp(self, is_white)
		if mode == 3:
			table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
		#En paasant
		if TurnManager.history.size() > 1 and posi.y == 4:
			var last_move = TurnManager.history[TurnManager.history.size() -1]
			if last_move.end.x == posi.x - 1 and last_move.start == Vector2(posi.x - 1, posi.y + 2)and last_move.piece == Move.PieceType.P:
				if mode == 0:
					if table.tile_base_on_position(change_vector).piece_standing == null:
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
							pass
				if mode == 1:
					table.tile_base_on_position(change_vector).check_occ()
	if posi.x < 7:
		change_vector = posi + Vector2(1,1)
		if table.tile_base_on_position(change_vector).piece_standing != null:
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
					if table.tile_base_on_position(change_vector).piece_standing == table.tile_base_on_position(posi).protecting_from[0]:
						table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 4:
				if table.tile_base_on_position(change_vector).piece_standing.name == "king_b":
					table.piece_checking = self
					for piece in table.tile_base_on_position(posi).black_lamps:
						if piece.name.left(6) != "king_b":
							if piece.name.left(6) == "pawn_b":
								if piece.current_position - posi == Vector2(-1,1) or piece.current_position - posi == Vector2(-1,1):
									table.check_protectors = true
									break
								else:
									table.check_protectors = false
							else:
								table.check_protectors = true
								break
						else:
							table.check_protectors = false
					table.tile_base_on_position(change_vector).piece_standing.on_check()
		if mode == 2:
			table.tile_base_on_position(change_vector).add_lamp(self, is_white)
		if mode == 3:
			table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
		#En paasant
		if TurnManager.history.size() > 1 and posi.y == 4:
			var last_move = TurnManager.history[TurnManager.history.size() -1]
			if last_move.end.x == posi.x + 1 and last_move.start == Vector2(posi.x + 1, posi.y + 2) and last_move.piece == Move.PieceType.P:
				if mode == 0:
					if table.tile_base_on_position(change_vector).piece_standing == null:
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
							pass
				if mode == 1:
					table.tile_base_on_position(change_vector).check_occ()
	change_vector = posi + Vector2(0,2)
	if  posi.y == 1:
		if table.tile_base_on_position(posi + Vector2(0,1)).piece_standing == null:
			if table.tile_base_on_position(posi + Vector2(0,2)).piece_standing == null:
				if mode == 0:
					if table.tile_base_on_position(change_vector).piece_standing == null:
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
	if mode == 5:
		if posi.x > 0:
			change_vector = posi + Vector2(-1,1)
			if table.tile_base_on_position(change_vector).piece_standing != null:
				if table.tile_base_on_position(change_vector).piece_standing.name == "king_b":
					table.tile_base_on_position(change_vector).piece_standing.reset_check()
		if posi.x < 7:
			change_vector = posi + Vector2(1,1)
			if table.tile_base_on_position(change_vector).piece_standing != null:
				if table.tile_base_on_position(change_vector).piece_standing.name == "king_b":
					table.tile_base_on_position(change_vector).piece_standing.reset_check()
		if table.piece_checking == self:
			table.piece_checking = null
