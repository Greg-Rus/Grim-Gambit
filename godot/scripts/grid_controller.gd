extends Node

var grid_data : Array
var grid_dimensions : Vector2i
var grid_max_index : Vector2i

class cell:
	var cooridnates : Vector2i
	var environment
	var unit
	

func initialize_grid(dimensions:Vector2i):
	grid_dimensions = dimensions
	grid_max_index = grid_dimensions - Vector2i.ONE
	
	for i in grid_dimensions.x * grid_dimensions.y:
		var cell = cell.new()
		var x_coordinate = i % grid_dimensions.x
		var y_coordinate = i / grid_dimensions.x 
		cell.cooridnates = Vector2i(x_coordinate, y_coordinate)
		grid_data.append(cell)