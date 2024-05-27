extends Node
class_name InputHandler

@onready var grid : Grid = %TileMap
var last_pointer_cell : Vector2i = Vector2i.MIN

func _input(event):
	if State.selected_unit != null:
		handle_mouse_move()
	#if event is InputEventMouseButton:
		#handle_mouse_click(event)
		
func handle_mouse_move():
	var cell_under_pointer : Vector2i = grid.get_grid_cell_under_pointer()
	if cell_under_pointer == last_pointer_cell:
		return
	if grid.is_grid_position_in_bounds(cell_under_pointer) == false:
		return
	
	last_pointer_cell = cell_under_pointer
	EventBuss.pointer_cell_changed.emit(cell_under_pointer)
