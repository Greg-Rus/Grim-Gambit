extends Node2D
class_name WorldManager

@export var room_dimensions : Vector2i = Vector2i(8,8)

@onready var room_builder : RoomBuilder = %RoomBuilder
@onready var unit_selection_indicator : Sprite2D = %UnitSelectionIndicator
@onready var test_unit : PackedScene = preload("res://units/unit.tscn")
var cell_pixel_size = 16
var room_offset : Vector2
var grid_dimensions : Vector2i

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

func spawn_unit():
	var unit_start_position = grid_to_tile_center(Vector2i(grid_dimensions.x/2, grid_dimensions.y))
	var unit = test_unit.instantiate() as AnimatedSprite2D
	unit.position = unit_start_position
	add_child(unit)

func handle_mouse_click(event : InputEventMouseButton):
	if event.button_index == 1 and event.pressed:
			var clicked_cell = world_to_grid(event.position)
			if cell_in_bounds(clicked_cell):
				var cell_center_position = grid_to_tile_center(clicked_cell)
				unit_selection_indicator.position = cell_center_position
				unit_selection_indicator.visible = true
			else :
				unit_selection_indicator.visible = false

func world_to_grid(world_pposition : Vector2) -> Vector2i:
	var position_origin_relative = world_pposition - room_offset
	var position_normalized = Vector2(floor(position_origin_relative.x / 16), floor(position_origin_relative.y / 16)) #position_origin_relative / 16
	return position_normalized

func grid_to_tile_center(grid_position : Vector2) -> Vector2:
	return (grid_position * 16) + room_offset + (Vector2(0.5, 0.5) * cell_pixel_size)
	
func cell_in_bounds(grid_position : Vector2i):
	return grid_position.x <= grid_dimensions.x && \
	grid_position.x >= 0 &&\
	grid_position.y <= grid_dimensions.y &&\
	grid_position.y >= 0
