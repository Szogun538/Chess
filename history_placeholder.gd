extends Node2D

@onready var Game_main: Node2D = get_parent()
var history: Array[Move] = TurnManager.history
var turn_count: int = 0

#Encoding
var type = {
	Move.MoveType.MOVE_ALONE: "",
	Move.MoveType.MOVE_MULTI: "",
	Move.MoveType.KILL: "x",
	Move.MoveType.EP: "en",
	Move.MoveType.CASTLING_S: "O-O",
	Move.MoveType.CASTLING_L: "O-O-O"
	}
var special = {
	Move.SpecialType.NULL: "",
	Move.SpecialType.CHECK: "+",
	Move.SpecialType.CHECKMATE: "#"
	}
var Pposition = {
	0.0: "a",
	1.0: "b",
	2.0: "c",
	3.0: "d",
	4.0: "e",
	5.0: "f",
	6.0: "g",
	7.0: "h"
	}
var promotion_pieces = {
	"queen": "Q",
	"rook": "R",
	"knight": "K",
	"bishop": "B",
	}

func _ready() -> void:
	Game_main.turn_change.connect(_on_turn_change)
	Game_main.p_t_c.connect(_on_p_t_c)

func encoding(move: Move):
	var output: String = ""
	var sposx: String = Pposition[move.start.x]
	var eposx: String = Pposition[move.end.x]
	var eposy: String = str(move.end.y +1).left(1)
	var piece: String = str(Move.PieceType.find_key(move.piece))
	if  move.piece == Move.PieceType.P:
		if move.type == Move.MoveType.KILL:
			output += sposx + type[Move.MoveType.KILL] + eposx + eposy
		elif move.type == Move.MoveType.MOVE_ALONE:
			output += eposx + eposy
	else:
		# if move.type == Move.MoveType.MOVE_ALONE:
		# 	output += piece + eposx + eposy
		if move.type == Move.MoveType.MOVE_MULTI:
			if move.kill_for_multi:
				output += piece + sposx + type[Move.MoveType.KILL] + eposx + eposy
			else:
				output += piece + sposx +  eposx + eposy
		elif move.type == Move.MoveType.CASTLING_S or move.type == Move.MoveType.CASTLING_L:
			output += type[move.type]
		else:
			output += piece + type[move.type] + eposx + eposy
		# if move.type == Move.MoveType.KILL:
		# 	output += piece + type[Move.MoveType.KILL] + eposx + eposy
	if move.promotion != "":
		output += "=" + promotion_pieces[move.promotion]
	if move.special != Move.SpecialType.NULL:
		output += special[move.special]
	return output

func _on_p_t_c():
	turn_count += 1
	$RichTextLabel.text += str(turn_count) + ". "


func _on_turn_change():
	$RichTextLabel.text += encoding(history[history.size() -1]) + " "
	pass
