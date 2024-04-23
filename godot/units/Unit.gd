extends AnimatedSprite2D
class_name Unit

@export var movement_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var movement_distance : int = 1

func get_movement_pattern() -> Array:
	var moves = []
	var pattern = Constants.get_move_pattern_data(movement_pattern)
	for i in movement_distance:
		for move in pattern:
			moves.append(move * i)
	return moves
