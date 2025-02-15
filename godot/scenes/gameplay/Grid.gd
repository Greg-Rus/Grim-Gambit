extends TileMap
class_name Grid

static var instance : Grid

func _ready():
	ServiceLocator.grid_manager = self
	if(instance == null):
		instance = self

func is_grid_position_in_bounds(grid_position : Vector2i) -> bool:
	return get_cell_tile_data(0, grid_position) != null

func is_local_position_in_bounds(local_position : Vector2) -> bool:
	return get_cell_tile_data(0, local_to_map(local_position)) != null
	
func get_grid_mouse_position() -> Vector2:
	return get_local_mouse_position()

func get_grid_cell_under_pointer() -> Vector2i:
	return local_to_map(get_local_mouse_position())
	
func grid_to_world(grid_position : Vector2i) -> Vector2:
	return map_to_local(grid_position)
	
func world_to_grid(world_position : Vector2):
	return local_to_map(world_position)

func get_cell_type(cell : Vector2i) -> Constants.TileType:
	var data = get_cell_tile_data(0, cell)
	var type = data.get_custom_data("type")
	return type

func is_cell_walkable(cell: Vector2i) -> bool:
	return	is_grid_position_in_bounds(cell) && \
			get_cell_type(cell) == Constants.TileType.Ground
