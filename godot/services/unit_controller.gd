extends Node
class_name UnitController

@onready var grid : Grid = %TileMap
@onready var entity_manager : EntityManager = %EntityManager
@onready var overlay_manager : OveralyManager = %OverlayManager

var unit_walk_cells : Array = []
var unit_attack_cells : Array = []

func _ready():
	ServiceLocator.unit_controller = self
	EventBuss.unit_selected.connect(on_unit_selected)
	
func on_unit_selected(unit : Entity):
	calculate_walkable_cells(unit)
	calculate_attackable_cells(unit)
	overlay_manager.spawn_walkable_overlays(unit_walk_cells)
	overlay_manager.spawn_attackable_overlays(unit_attack_cells)

func is_walkable(coordinates:Vector2i) -> bool:
	return grid.is_cell_walkable(coordinates) && entity_manager.get_entity_at_position(coordinates) == null
	
func is_attackable(coordinates:Vector2i) -> bool:
	return grid.is_cell_walkable(coordinates)

func is_in_walking_range(coordinate:Vector2i) -> bool:
	return unit_walk_cells.has(coordinate)
	
func is_in_attack_range(coordinate:Vector2i) -> bool:
	return unit_attack_cells.has(coordinate)
	
func calculate_pattern_zone(pattern:Array, range:int, origin:Vector2i) -> Array:
	var zone = []
	var ureachable_positions = [] #if a cell in the pattern is not reachable, then all cells exptend by unit reange are also not reachable. Unles the unit flies.
	for i in range(1, range + 1):
		for position in pattern:
			if(ureachable_positions.has(position)):
				continue
			var reachable_position = origin + (position * i)
			if(is_walkable(reachable_position)):
				zone.append(reachable_position)
			else:
				ureachable_positions.append(position)
	return zone
	
func calculate_walkable_cells(unit:Entity):
	var movement_component = unit.get_component(Constants.EntityComponent.Movement) as MovementComponent
	if movement_component == null:
		push_error("Trying to draw move pattern for unit that has no Movement component")
	var pattern = movement_component.get_movement_pattern()
	var range = movement_component.movement_distance
	unit_walk_cells = calculate_pattern_zone(pattern, range, unit.cell)
	
func calculate_attackable_cells(unit : Entity):
	var attack_component = unit.get_component(Constants.EntityComponent.Attack) as AttackComponent
	var pattern = attack_component.get_attack_pattern()
	var range = attack_component.attack_range
	unit_attack_cells = calculate_pattern_zone(pattern, range, unit.cell)
