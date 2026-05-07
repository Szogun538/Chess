extends Node


var history: Array[Move]

func add(new_move: Move):
	history.append(new_move)

func get_last():
	return history[history.size()]
	
func get_prelast():
	if history.size() > 0:
		return history[history.size()-1]
	else:
		print("not big enough")
