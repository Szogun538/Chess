extends Node2D


# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	print(available(Vector2(0,0), false))
signal change_state
var turn: bool = true
var piece_checking: Node2D = null

func tile_base_on_position(chess_posistion: Vector2):
	var tiles = get_tree().get_nodes_in_group("Tiles")
	for i in tiles:
		if i.chess_position == chess_posistion:
			return i

func available(chess_posistion: Vector2, color: bool):
	var tile = tile_base_on_position(chess_posistion)
	if tile.chess_position == chess_posistion:
		if tile.piece_standing == null:
			return false
		elif tile.piece_standing.is_white != color:
			return false
		else:
			return true
func change_position_state(chess_posistion: Vector2, occupied: bool):
	var tile = tile_base_on_position(chess_posistion)
	if tile.chess_position == chess_posistion:
		tile.is_occupied = occupied
		emit_signal("change_state")

func reset_attack(color: bool):
	var pieces
	if color:
		pieces = get_tree().get_nodes_in_group("pieces_w")
	else :
		pieces = get_tree().get_nodes_in_group("pieces_b")
	for i in pieces:
		i.reset_attacking()



# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
#
# func tile_status(tile_position: Vector2):
# 	var tiles = get_children()
