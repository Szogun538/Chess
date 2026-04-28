extends Node2D

var white_time: float = 5 * 60
var black_time: float = 5 * 60
var pluser: float = 3
var moved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var turn = $Table.turn
	if $Table.first_moved:
		if $Table.first_moved:
			if turn:
				if $Table.change_turn : 
					$Table.change_turn = false
					black_time += 3
				white_time += -1 * 1 * delta
			else:
				if $Table.change_turn: 
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
