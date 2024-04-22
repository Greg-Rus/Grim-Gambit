extends Node2D
class_name WorldManager

@export var room_dimensions : Vector2i = Vector2i(8,8)

@onready var room_builder : RoomBuilder = %RoomBuilder
@onready var unit_selection_indicator : Sprite2D = %UnitSelectionIndicator
@onready var grid : Grid = %TileMap
@onready var test_unit : PackedScene = preload("res://units/unit.tscn")
@onready var walkable_overlay : PackedScene = preload("res://nodes/tile_overlay.tscn")
var cell_pixel_size = 16
var room_offset : Vector2
var grid_dimensions : Vector2i
var entities = {}
var selected_unit : Unit
var spwned_walkable_overlays : Array
	
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
		var grid_cell : Vector2i = grid.get_grid_cell_under_pointer()
		
		if (is_unit_clicked(grid_cell)):
			handle_unit_clicked(entities[grid_cell])
			return
			
		if(grid.is_grid_position_in_bounds(grid_cell) == false):
			handle_click_outside_map()
			return
		
		handle_tile_map_click(grid_cell)
		
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
	
func handle_tile_map_click(coordinates : Vector2i):
	try_unselect_unit()
	
func is_unit_clicked(map_coordinate : Vector2i):
	return entities.keys().has(map_coordinate)
		
func is_walkable(coordinates:Vector2i, type:int) -> bool:
	var cell_type = type as Constants.TileType
	return cell_type == Constants.TileType.Ground && entities.keys().has(coordinates) == false

func spawn_unit():
	var grid_sapwn_position = Vector2i(grid_dimensions.x/2, grid_dimensions.y)
	var unit_start_position = grid.map_to_local(grid_sapwn_position)
	var unit = test_unit.instantiate() as Unit
	grid.add_child(unit)
	unit.position = unit_start_position
	entities[grid_sapwn_position] = unit

func spawn_walkable_overlays(coordinates : Array):
	pass
	#iterate over cooridantes. Apply to unit coordinate. Translate to map_to_local.
