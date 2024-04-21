extends Node2D
class_name WorldManager

@export var room_dimensions : Vector2i = Vector2i(8,8)

@onready var room_builder : RoomBuilder = %RoomBuilder
@onready var unit_selection_indicator : Sprite2D = %UnitSelectionIndicator
@onready var tile_map : TileMap = %TileMap
@onready var test_unit : PackedScene = preload("res://units/unit.tscn")
@onready var walkable_overlay : PackedScene = preload("res://nodes/tile_overlay.tscn")
var cell_pixel_size = 16
var room_offset : Vector2
var grid_dimensions : Vector2i
var entities = {}
var selected_unit : Unit
var spwned_walkable_overlays : Array

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
		var clicked_cell_coordinates : Vector2i = tile_map.local_to_map(tile_map.get_local_mouse_position())
		
		if (is_unit_clicked(clicked_cell_coordinates)):
			handle_unit_clicked(entities[clicked_cell_coordinates])
			return
			
		var data : TileData = tile_map.get_cell_tile_data(0, clicked_cell_coordinates)
		if(data == null):
			handle_click_outside_map()
			return
		
		handle_tile_map_click(clicked_cell_coordinates, data)
		
func handle_unit_clicked(unit : Unit):
	selected_unit = unit
	highlight_selected_unit()
	
func highlight_selected_unit():
	if(selected_unit == null):
		push_error("Tried to highlight a unit, but no unit selected.")
	unit_selection_indicator.visible = true
	unit_selection_indicator.position = selected_unit.position
	draw_movement_pattern()

func draw_movement_pattern():
	print(selected_unit.get_movement_pattern())
	
func try_unselect_unit():
	selected_unit = null
	unit_selection_indicator.visible = false
		
func handle_click_outside_map():
	try_unselect_unit()
	
func handle_tile_map_click(coordinates : Vector2i, tileData : TileData):
	try_unselect_unit()
	
func is_unit_clicked(map_coordinate : Vector2i):
	return entities.keys().has(map_coordinate)
		
func is_walkable(coordinates:Vector2i, type:int) -> bool:
	var cell_type = type as Constants.TileType
	return cell_type == Constants.TileType.Ground && entities.keys().has(coordinates) == false

func spawn_unit():
	var grid_sapwn_position = Vector2i(grid_dimensions.x/2, grid_dimensions.y)
	var unit_start_position = tile_map.map_to_local(grid_sapwn_position)
	var unit = test_unit.instantiate() as Unit
	tile_map.add_child(unit)
	unit.position = unit_start_position
	entities[grid_sapwn_position] = unit

func spawn_walkable_overlays(coordinates : Array):
	pass
	#iterate over cooridantes. Apply to unit coordinate. Translate to map_to_local.
