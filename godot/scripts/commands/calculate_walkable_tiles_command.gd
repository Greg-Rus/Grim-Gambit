extends BaseCommand
class_name CalculateWalkableTilesCommand

func execute() -> void:
	detect_walkable_cells(State.selected_unit)

func detect_walkable_cells(unit:Entity):
	var movement_component = unit.get_component(Constants.EntityComponent.Movement) as MovementComponent
	if movement_component == null:
		push_error("Trying to draw move pattern for unit that has no Movement component")
	var pattern = movement_component.get_movement_pattern()
	var range = movement_component.movement_distance
	var illegal_positions = []
	for i in range(1, range + 1):
		for position in pattern:
			if(illegal_positions.has(position)):
				continue
			var move_position = unit.cell + (position * i)
			if(is_walkable(move_position)):
				spawned_walkable_overlays[move_position] = null
			else:
				illegal_positions.append(position)
