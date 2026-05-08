extends RefCounted
class_name Move

enum MoveType{
	MOVE_ALONE,
	MOVE_MULTI,
	KILL,
	EP,			#en passant
	CASTLING_S,
	CASTLING_L,
	} 
enum SpecialType{
	NULL,
	CHECK,
	CHECKMATE,
	}
enum PieceType{
	P,
	R,
	B,
	Q,
	K,
	N
	}
var promotion: String
var start: Vector2
var end: Vector2
var type: MoveType
var special: SpecialType
var piece: PieceType
var kill_for_multi: bool = false
func _init(s: Vector2, e: Vector2, t: MoveType, p = piece):
	piece = p
	start = s
	end = e
	type = t
