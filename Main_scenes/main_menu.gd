extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_2_pressed():
	var count: int = 0
	var count_turn: int = 0
	for move in TurnManager.history:
		if count %2 == 0:
			count_turn += 1
			print("--------------------- " + str(count_turn) + ". ----------------------")
		print(Move.PieceType.find_key(move.piece))
		print(move.start)
		print(move.end)
		print(Move.MoveType.find_key(move.type))
		print(Move.SpecialType.find_key(move.special))
		print(move.promotion)
		count += 1
