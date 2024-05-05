extends Node2D
class_name EntityManager

static var instance : EntityManager

func _ready():
	if(instance == null):
		instance = self
	EventBuss.entity_changed_cell.connect(update_entity_cell)

var units_to_grid = {} #obsolete
var grid_to_units = {} #obsolete

var entity_to_cell = {}
var cell_to_unit = {}

var selected_unit : Unit

func select_unit(unit : Unit):
	selected_unit = unit
	EventBuss.unit_selected.emit(selected_unit)
	
func unselect_unit():
	selected_unit = null
	EventBuss.unit_unselected.emit()
	
func is_unit_selected() -> bool:
	return selected_unit != null

func update_unit_position(unit : Unit, grid_position : Vector2i): #obsolete
	if(units_to_grid.has(unit)):
		var position = units_to_grid[unit]
		units_to_grid.erase(unit)
		grid_to_units.erase(position)
	units_to_grid[unit] = grid_position
	grid_to_units[grid_position] = unit
	
func update_entity_cell(entity : Entity):
	var new_cell = entity.cell
	if(entity_to_cell.has(entity)):
		var old_cell = entity_to_cell[entity]
		entity_to_cell.erase(entity)
		cell_to_unit.erase(old_cell)
	entity_to_cell[entity] = new_cell
	cell_to_unit[new_cell] = entity
		
func get_unit_position(unit : Unit) -> Vector2i:
	if units_to_grid.has(unit):
		return units_to_grid[unit]
	else:
		printerr("Unit not in entity manager", unit)
		return Vector2i.MIN
	
func get_unit_at_position(grid_position : Vector2i) -> Unit:
	if grid_to_units.has(grid_position):
		return grid_to_units[grid_position]
	return null
	
func destroy_unit(unit : Unit):
	var position = units_to_grid[unit]
	units_to_grid.erase(unit)
	grid_to_units.erase(position)
	unit.queue_free()
