extends Node2D

var is_white: bool
var respawn_position: Vector2
var tile = preload("res://SubScenesForGameplay/Promotion/promotion_tile.tscn")
var selected_piece: String 
signal select

var white_pieces_picture = {
	0: preload("res://pictures/Chess_qlt60.png"),
	1: preload("res://pictures/Chess_rlt60.png"),
	2: preload("res://pictures/Chess_nlt60.png"),
	3: preload("res://pictures/Chess_blt60.png")
	}
var black_pieces_picture = {
	0: preload("res://pictures/Chess_qdt60.png"),
	1: preload("res://pictures/Chess_rdt60.png"),
	2: preload("res://pictures/Chess_ndt60.png"),
	3: preload("res://pictures/Chess_bdt60.png")
	}
var piece_type = {
	0: "queen",
	1: "rook",
	2: "knight",
	3: "bishop",
	}

func _ready() -> void:
	var tiles: Array[Node]
	for i in range(4):
		tiles.append(tile.instantiate())
	var cs = 0
	for new_tile in tiles:
		if is_white:
			new_tile.position.y = position.y + (50 * cs)
			new_tile.texture = white_pieces_picture[cs]
			new_tile.piece = piece_type[cs]
			new_tile.selected.connect(_on_selection.bind(piece_type[cs]))
		else:
			new_tile.position.y = position.y + (-50 * cs)
			new_tile.texture = black_pieces_picture[cs]
			new_tile.piece = piece_type[cs]
			new_tile.selected.connect(_on_selection.bind(piece_type[cs]))
		add_child(new_tile)
		cs += 1

func _on_selection(piece: String):
	selected_piece = piece
	emit_signal("select")
