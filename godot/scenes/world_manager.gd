extends Node2D
class_name WorldManager

@export var room_dimensions : Vector2i = Vector2i(8,8)

@onready var room_builder : RoomBuilder = %RoomBuilder
@onready var unit_selection_indicator : Sprite2D = %UnitSelectionIndicator
@onready var tile_map : TileMap = %TileMap
@onready var test_unit : PackedScene = preload("res://units/unit.tscn")
var cell_pixel_size = 16
var room_offset : Vector2
var grid_dimensions : Vector2i
var entities = {}

class grid_cell:
	var unit
	var environment
	
func _ready():
	grid_dimensions = room_dimensions - Vector2i.ONE
	var screen_center = get_viewport_rect().size * 0.5
	room_offset = screen_center + Vector2(room_dimensions) * 0.5 * cell_pixel_size * -1

	room_builder.make_room(room_dimensions, room_offset)
	spawn_unit()

func _input(event):
	if event is InputEventMouseButton:
		handle_mouse_click(event)
		
func handle_mouse_click(event : InputEventMouseButton):
	if event.button_index == 1 and event.pressed:
		var clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
		var data = tile_map.get_cell_tile_data(0, clicked_cell)
		if(data == null):
			print("Did not click map")
			return
		var type = data.get_custom_data("type")
		print("Walkable ",is_walkable(clicked_cell,type))
		
func is_walkable(coordinates:Vector2i, type:int) -> bool:
	var cell_type = type as Constants.TileType
	return cell_type == Constants.TileType.Ground && entities.keys().has(coordinates) == false

func spawn_unit():
	var grid_sapwn_position = Vector2i(grid_dimensions.x/2, grid_dimensions.y)
	var unit_start_position = tile_map.map_to_local(grid_sapwn_position)
	var unit = test_unit.instantiate() as AnimatedSprite2D
	tile_map.add_child(unit)
	unit.position = unit_start_position
	entities[grid_sapwn_position] = unit
