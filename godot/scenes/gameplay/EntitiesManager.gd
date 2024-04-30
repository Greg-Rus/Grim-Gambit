extends Node2D
class_name EntityManager

static var instance : EntityManager

func _ready():
	if(instance == null):
		instance = self

var units_to_grid = {}
var grid_to_units = {}

func update_unit_position(unit : Unit, grid_position : Vector2i):
	if(units_to_grid.has(unit)):
		var position = units_to_grid[unit]
		units_to_grid.erase(unit)
		grid_to_units.erase(position)
	units_to_grid[unit] = grid_position
	grid_to_units[grid_position] = unit
		
func get_unit_position(unit : Unit) -> Vector2i: #need try logic 
	return units_to_grid[unit]
	
func get_unit_at_position(grid_position : Vector2i) -> Unit: #need try logic 
	return grid_to_units[grid_position]
