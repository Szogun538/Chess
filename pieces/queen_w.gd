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
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	var start_tile_position = $Piece.start_tile.chess_position
	moves(start_tile_position, 0)

func _on_b_dropped():
	var tile_position = $Piece.start_tile.chess_position
	table.tile_base_on_position(tile_position).check_occ()
	moves(tile_position, 1)
	if table.game_over:
		get_tree().change_scene_to_file("res://Main_scenes/main_menu.tscn")

func _on_b_succsesfull_drop():
	table.turn =  not table.turn
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
	var scan_tiles: Array[Node2D] = []
	var occupied_scan_tiles: Array[Node2D] = []
	var loop_tile = posi
	var direction: Array[Vector2] = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0),Vector2(1,1), Vector2(1,-1), Vector2(-1,-1), Vector2(-1,1)]
	for dir in direction:
		while loop_tile.x < 7 and loop_tile.y < 7 and dir == Vector2(1,1) or loop_tile.x < 7 and loop_tile.y > 0 and dir == Vector2(1,-1) or loop_tile.x > 0 and loop_tile.y > 0 and dir == Vector2(-1,-1) or loop_tile.x > 0 and loop_tile.y < 7 and dir == Vector2(-1,1) or loop_tile.x > 0 and dir == Vector2(-1,0) or loop_tile.x < 7 and dir == Vector2(1,0) or loop_tile.y > 0 and dir == Vector2(0,-1) or loop_tile.y < 7 and dir == Vector2(0,1):
			loop_tile += dir
			if mode <= 2:
				if mode == 0:
					if table.tile_base_on_position(posi).protecting_from.size() == 0:
						if table.piece_checking != null:
							if table.tile_base_on_position(loop_tile).path_when_pro(table.piece_checking):
								table.change_position_state(loop_tile, table.available(loop_tile, is_white))
							if table.tile_base_on_position(loop_tile).piece_standing == table.piece_checking:
								table.change_position_state(loop_tile, table.available(loop_tile, is_white))
						else:
							table.change_position_state(loop_tile, table.available(loop_tile, is_white))
					else:
						if table.tile_base_on_position(loop_tile).path_when_pro(table.tile_base_on_position(posi).protecting_from[0]):
							table.change_position_state(loop_tile, table.available(loop_tile, is_white))
						if table.tile_base_on_position(loop_tile).piece_standing != null:
							if table.tile_base_on_position(posi).protecting_from[0] == table.tile_base_on_position(loop_tile).piece_standing:
								table.change_position_state(loop_tile, table.available(loop_tile, is_white))

				if mode == 1:
					table.tile_base_on_position(loop_tile).check_occ()
				if mode == 2:
					table.tile_base_on_position(loop_tile).add_lamp(self, is_white)
				if table.tile_base_on_position(loop_tile).piece_standing != null:
					if table.tile_base_on_position(loop_tile).piece_standing.name != "king_b":
						break
			if mode == 3:
				table.tile_base_on_position(loop_tile).remove_lamp(self, is_white)
			if mode == 4:
				scan_tiles.append(table.tile_base_on_position(loop_tile))
				if table.tile_base_on_position(loop_tile).piece_standing != null:
					occupied_scan_tiles.append(table.tile_base_on_position(loop_tile))
					if table.tile_base_on_position(loop_tile).piece_standing.name == "king_b":
						if occupied_scan_tiles.size() == 1:
							if table.tile_base_on_position(current_position).check_for_pawn(current_position, not is_white, true):
								for i in scan_tiles:
									if not i.check_for_pawn(i.chess_position, not is_white, false) or i.chess_position == loop_tile:
										table.check_protectors = false
									else:
										table.check_protectors = true
										break
							table.piece_checking = self
							table.tile_base_on_position(loop_tile).piece_standing.on_check()
						for i in scan_tiles:
							if i.piece_standing == null:
								i.path_to_king_from.append(self) 
							elif i.piece_standing.name != "king_b" and i.piece_standing.is_white != is_white:
								if occupied_scan_tiles.size() == 2:
									i.protecting_from.append(self)
								if occupied_scan_tiles.size() > 2:
									i.path_to_king_from.append(self)
							else:
								i.path_to_king_from.append(self)
						break
			if mode == 5:
				if table.tile_base_on_position(loop_tile).piece_standing != null:
					if table.tile_base_on_position(loop_tile).piece_standing.name == "king_b":
						table.tile_base_on_position(loop_tile).piece_standing.reset_check()
				if table.piece_checking == self:
					table.piece_checking = null
				table.tile_base_on_position(loop_tile).path_to_king_from.erase(self)
				table.tile_base_on_position(loop_tile).protecting_from.erase(self)
		scan_tiles = []
		occupied_scan_tiles = []
		loop_tile = posi
