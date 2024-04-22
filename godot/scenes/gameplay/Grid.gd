extends TileMap
class_name Grid

func is_grid_position_in_bounds(grid_position : Vector2i) -> bool:
	return get_cell_tile_data(0, grid_position) != null

func is_local_position_in_bounds(local_position : Vector2) -> bool:
	return get_cell_tile_data(0, local_to_map(local_position)) != null
	
func get_grid_mouse_position() -> Vector2:
	return get_local_mouse_position()

func get_grid_cell_under_pointer() -> Vector2i:
	return local_to_map(get_local_mouse_position())

func get_cell_type(cell : Vector2i) -> Constants.TileType:
	var data = get_cell_tile_data(0, cell)
	var type = data.get_custom_data("type")
	return Constants.TileType.Wall
