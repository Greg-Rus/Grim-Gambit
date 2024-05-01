extends AnimatedSprite2D
class_name Unit

@export var movement_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var movement_distance : int = 1
@export var attack_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var attack_range : int = 1

@export var is_player_controled : bool = true

var grid_position : Vector2i

func move_to_grid_position(grid_coordinates : Vector2i):
	grid_position = grid_coordinates
	position = Grid.instance.grid_to_world(grid_coordinates)
	EntityManager.instance.update_unit_position(self, grid_position)

func get_movement_pattern() -> Array:
	var pattern_positions = []
	var pattern = Constants.get_pattern_data(movement_pattern)
	for i in range(1, movement_distance + 1):
		for position in pattern:
			pattern_positions.append(position * i)
	return pattern_positions
	
func get_attack_pattern() -> Array:
	var pattern_positions = []
	var pattern = Constants.get_pattern_data(attack_pattern)
	for i in range(1, attack_range + 1):
		for position in pattern:
			pattern_positions.append(position * i)
	return pattern_positions
