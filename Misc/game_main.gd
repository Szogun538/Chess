extends Node2D

var white_time: float = 5 * 60
var black_time: float = 5 * 60
var pluser: float = 3
var moved: bool = false
var history: Array[Move]
var turn_count: int = 0
signal turn_change
signal p_t_c


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var turn = $Table.turn
	if $Table.first_moved:
		if $Table.first_moved:
			if turn:
				if $Table.change_turn : 
					turn_count += 1
					emit_signal("turn_change")
					$Table.change_turn = false
					black_time += 3
				white_time += -1 * 1 * delta
			else:
				if $Table.change_turn: 
					emit_signal("p_t_c")
					emit_signal("turn_change")
					$Table.change_turn = false
					if moved:
						white_time += 3
					moved = true
				black_time += -1 * 1 * delta
	$WhiteTimer/Label.text = seconds_to_time(white_time)
	$BlackTimer/Label.text = seconds_to_time(black_time)


func seconds_to_time(time: float):
	var minutes = time / 60
	var seconds = (time - floor(minutes)*60)
	if int(minutes) < 10:
		if int(seconds) < 10:
			return "0" + str(int(minutes)) + ":0" + str(int(seconds))
		else:
			return "0" + str(int(minutes)) + ":" + str(int(seconds))
	else:
		if int(seconds) < 10:
			return str(int(minutes)) + ":0" + str(int(seconds))
		else:
			return str(int(minutes)) + ":" + str(int(seconds))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TurnManager.add(Move.new(Vector2(0,0), Vector2(7,5), Move.MoveType.KILL))
	pass # Replace with function body.


func _on_button_pressed():
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
