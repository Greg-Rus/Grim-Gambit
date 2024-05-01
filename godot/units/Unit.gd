extends AnimatedSprite2D
class_name Unit

@export var movement_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var movement_distance : int = 1
@export var attack_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var attack_range : int = 1

var grid_position : Vector2i

func move_to_grid_position(grid_coordinates : Vector2i):
	grid_position = grid_coordinates
	position = Grid.instance.grid_to_world(grid_coordinates)
	EntityManager.instance.update_unit_position(self, grid_position)

func get_movement_pattern() -> Array:
	var moves = []
	var pattern = Constants.get_move_pattern_data(movement_pattern)
	for i in movement_distance:
		for move in pattern:
			moves.append(move * i)
	return moves
	
func get_attack_pattern() -> Array:
	var attacks = []
	var pattern = Constants.get_move_pattern_data(attack_pattern)
	for i in attack_range:
		for attack in pattern:
			attacks.append(attack * i)
	return attacks
