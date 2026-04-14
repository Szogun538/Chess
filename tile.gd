extends Node2D

signal slot_data(occupied)
@export var piece_standing: Node2D
@export var chess_position: Vector2
var is_occupied :bool
var white_lamps: Array[Node2D] = []
var black_lamps: Array[Node2D] = []
var protecting_from: Array[Node2D] = []
var path_to_king_from: Array[Node2D] = []

#temp
var label_text: String = ""

func _process(delta: float) -> void:
	# $Label.text = label_text
	# for i in path_to_king_from:
	# 	$Label.text += str(i.name) + "\n"
	pass

func _ready():
	get_parent().change_state.connect(_on_change_state)
	if int(chess_position.x + chess_position.y) % 2 == 0:
		$ColorRect.color = Color("#b58863")  # dark
	else:
		$ColorRect.color = Color("#f0d9b5")  # light
	check_occ()
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)
	if piece_standing != null:
		piece_standing.current_position = chess_position

func check_occ():
	is_occupied = true
	$PointLight2D.hide()
	$PointLight2D2.hide()

func add_lamp(piece: Node2D, is_white: bool):
	var exist = false
	if is_white:
		for i in white_lamps:
			if i == piece:
				exist = true
		if not exist:
			white_lamps.push_front(piece)
	else:
		for i in black_lamps:
			if i == piece:
				exist = true
		if not exist:
			black_lamps.push_front(piece)
			
func remove_lamp(piece: Node2D, color: bool):
	var exist = false
	if color:
		for i in white_lamps:
			if i == piece:
				exist = true
		if exist:
			white_lamps.erase(piece)
	else:
		for i in black_lamps:
			if i == piece:
				exist = true
		if exist:
			black_lamps.erase(piece)

func check_for_pawn(current_position: Vector2, color: bool, mode: bool):
	var defence: bool = false
	if color:
		for i in white_lamps:
			if i.name.left(6) == "pawn_w":
				if i.current_position == chess_position - Vector2(0,1) or i.current_position == chess_position - Vector2(0,2) and i.current_position.y == 1:
					defence = true
				else:
					if mode:
						return false 
			else:
				if mode:
					return false
				else:
					if i.name != "king_w":
						return true
	else:
		for i in black_lamps:
			if i.name.left(6) == "pawn_b":
				if i.current_position == chess_position - Vector2(0,-1) or i.current_position == chess_position - Vector2(0,-2) and i.current_position.y == 6:
					defence = true
				else:
					if mode:
						return false 
			else:
				if mode:
					return false
				else:
					if i.name != "king_b":
						return true
	return defence

func reset_lamps():
	if white_lamps.size() > 0:
		for i in white_lamps:
			i.reset_light()
	if black_lamps.size() > 0:
		for i in black_lamps:
			i.reset_light()

func reset_attack():
	for i in path_to_king_from:
		i.reset_attacking()
	for i in protecting_from:
		i.reset_attacking()

func path_when_pro(attacker: Node2D):
	var exist: bool = false
	if path_to_king_from.size() == 0:
		return false
	for i in path_to_king_from:
		if i == attacker:
			exist = true
	return exist

func _on_change_state():
	if is_occupied:
		$PointLight2D.hide()
		$PointLight2D2.hide()
	else:
		if piece_standing == null:
			$PointLight2D.show()
		else:
			$PointLight2D2.show()

func _on_area_entered(other_area):
	if is_occupied:
		$PointLight2D.hide()
		$PointLight2D2.hide()
	else:
		$PointLight2D.hide()
		$PointLight2D2.show()

func _on_area_exited(other_area):
	if is_occupied:
		$PointLight2D.hide()
		$PointLight2D2.hide()
	else:
		if piece_standing == null:
			$PointLight2D.show()
			$PointLight2D2.hide()
		else:
			$PointLight2D.hide()
			$PointLight2D2.show()

func accept_drop():
	if not is_occupied:
		return false
	is_occupied = true
	emit_signal("slot_data", is_occupied)
	return true
