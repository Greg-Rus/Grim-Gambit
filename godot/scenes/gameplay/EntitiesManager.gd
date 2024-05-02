extends Node2D
class_name EntityManager

static var instance : EntityManager

func _ready():
	if(instance == null):
		instance = self

var units_to_grid = {}
var grid_to_units = {}
var selected_unit : Unit

func select_unit(unit : Unit):
	selected_unit = unit
	EventBuss.unit_selected.emit(selected_unit)
	
func unselect_unit():
	selected_unit = null
	EventBuss.unit_unselected.emit()
	
func is_unit_selected() -> bool:
	return selected_unit != null

func update_unit_position(unit : Unit, grid_position : Vector2i):
	if(units_to_grid.has(unit)):
		var position = units_to_grid[unit]
		units_to_grid.erase(unit)
		grid_to_units.erase(position)
	units_to_grid[unit] = grid_position
	grid_to_units[grid_position] = unit
		
func get_unit_position(unit : Unit) -> Vector2i: #need try logic 
	if units_to_grid.has(unit):
		return units_to_grid[unit]
	else:
		printerr("Unit not in entity manager", unit)
		return Vector2i.MIN
	
func get_unit_at_position(grid_position : Vector2i) -> Unit: #need try logic 
	if grid_to_units.has(grid_position):
		return grid_to_units[grid_position]
	return null
	
func destroy_unit(unit : Unit):
	var position = units_to_grid[unit]
	units_to_grid.erase(unit)
	grid_to_units.erase(position)
	unit.queue_free()
