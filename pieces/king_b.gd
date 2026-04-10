extends Node2D

var is_white = false
@onready var table = get_parent()
var current_position: Vector2

# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Piece.b_dragged.connect(_on_b_dragged)
	$Piece.dropped.connect(_on_b_dropped)
	$Piece.succsesfull_drop.connect(_on_b_succsesfull_drop)
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

func _on_b_succsesfull_drop():
	table.turn =  not table.turn
	var start_tile_position = $Piece.start_tile.chess_position
	var end_tile_position = $Piece.current_tile.chess_position
	current_position = end_tile_position
	if table.piece_checking != null:
		table.piece_checking.reset_attacking()
	table.tile_base_on_position(start_tile_position).reset_attack()
	table.reset_attack(not is_white)
	moves(start_tile_position, 3)
	moves(end_tile_position, 2)
	reset_check()
	table.tile_base_on_position(start_tile_position).reset_lamps()
	table.tile_base_on_position(current_position).reset_lamps()

func on_check():
	$Check.show()

func reset_check():
	$Check.hide()

func reset_light():
	moves(current_position, 3)
	moves(current_position, 2)


func moves(posi: Vector2, mode: int):
	var positions: Array[Vector2] = [Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(1,-1),Vector2(0,-1),Vector2(-1,-1),Vector2(-1,0),Vector2(-1,1)]
	for dir in positions:
		var change_vector = posi + dir
		if dir == positions[0] and posi.y < 7 or dir == positions[1] and posi.y < 7 and posi.x < 7 or dir == positions[2] and posi.x < 7 or dir == positions[3] and posi.y > 0 and posi.x < 7 or dir == positions[4] and posi.y > 0 or dir == positions[5] and posi.x > 0 and posi.y > 0 or dir == positions[6] and posi.x > 0 or dir == positions[7] and posi.x > 0 and posi.y < 7:
			if table.tile_base_on_position(change_vector).white_lamps.size() == 0:
				if mode == 0:
					table.change_position_state(change_vector, table.available(change_vector, is_white))
			if mode == 1:
				table.tile_base_on_position(change_vector).check_occ()
			if mode == 2:
				table.tile_base_on_position(change_vector).add_lamp(self, is_white)
			if mode == 3:
				table.tile_base_on_position(change_vector).remove_lamp(self, is_white)
