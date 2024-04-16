extends Node2D
class_name RoomBuilder

@onready var tile_map : TileMap = $LevelTileMap
@export var room_dimensions : Vector2i = Vector2i(8,8)
@export var white_ground : Vector2i = Vector2i(6,0)
@export var black_ground : Vector2i = Vector2i(6,1)
@export var walls_center : Vector2i = Vector2i(4,4)
	
func make_room(room_size : Vector2i, room_position : Vector2):
	tile_map.clear()
	self.room_dimensions = room_size
	tile_map.position = room_position
	
	for x in room_size.x:
		for y in room_size.y:
			var cell_position = Vector2i(x,y)
			var tile_id = get_ground_tile(cell_position)
			tile_map.set_cell(0, cell_position, 0, tile_id)
	
	surround_room_wiht_walls()
			
func surround_room_wiht_walls():
	for x in room_dimensions.x:
		tile_map.set_cell(0, Vector2i(x, -1), 0, walls_center + Vector2i.UP) #North wall
		tile_map.set_cell(0, Vector2i(x, -2), 0, walls_center + Vector2i.UP * 2) #North wall cap
		tile_map.set_cell(0, Vector2i(x, room_dimensions.y), 0, walls_center + Vector2i.DOWN) #South wall cap
		
	for y in range(-1, room_dimensions.y):
		tile_map.set_cell(0, Vector2i(-1, y), 0, walls_center + Vector2i.LEFT) #West wall cap
		tile_map.set_cell(0, Vector2i(room_dimensions.x, y), 0, walls_center + Vector2i.RIGHT) #East wall cap
		
	#Corners
	tile_map.set_cell(0, Vector2i(-1, -2), 0, walls_center + Vector2i.UP * 2 +  Vector2i.LEFT)
	tile_map.set_cell(0, Vector2i(room_dimensions.x, -2), 0, walls_center + Vector2i.UP * 2 +  Vector2i.RIGHT)
	tile_map.set_cell(0, Vector2i(room_dimensions.x, room_dimensions.y), 0, walls_center + Vector2i.DOWN +  Vector2i.RIGHT)
	tile_map.set_cell(0, Vector2i(-1, room_dimensions.y), 0, walls_center + Vector2i.DOWN +  Vector2i.LEFT)
			
func get_ground_tile(cell_position : Vector2i):
	var tile_number = cell_position.x + cell_position.y
	return white_ground if (tile_number % 2 == 0) else black_ground
