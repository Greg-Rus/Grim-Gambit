extends AnimatedSprite2D
class_name Unit

@export var movement_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn

func get_movement_pattern() -> Array:
		return Constants.get_move_pattern_data(movement_pattern)
