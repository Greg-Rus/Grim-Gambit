extends Node2D
class_name WorldManager

@export var room_dimensions : Vector2i = Vector2i(8,8)

@onready var room_builder : RoomBuilder = %RoomBuilder
@onready var unit_selection_indicator : Sprite2D = %UnitSelectionIndicator
@onready var grid : Grid = %TileMap
@onready var test_unit : PackedScene = preload("res://units/unit.tscn")
@onready var overlay_manager : OveralyManager = %OverlayManager
@onready var entity_manager : EntityManager = %EntityManager
var cell_pixel_size = 16
var room_offset : Vector2
var grid_dimensions : Vector2i

var selected_unit : Unit
	
func _ready():
	grid_dimensions = room_dimensions - Vector2i.ONE
	var screen_center = get_viewport_rect().size * 0.5
	room_offset = screen_center + Vector2(room_dimensions) * 0.5 * cell_pixel_size * -1

	room_builder.make_room(room_dimensions, room_offset)
	var player_unit_position = Vector2i(grid_dimensions.x/2, grid_dimensions.y)
	spawn_unit(player_unit_position)

func _input(event):
	if selected_unit != null:
		handle_mouse_move()
	if event is InputEventMouseButton:
		handle_mouse_click(event)
		
func handle_mouse_move():
	var cell_under_pointer : Vector2i = grid.get_grid_cell_under_pointer()
	if grid.is_grid_position_in_bounds(cell_under_pointer):
		if overlay_manager.is_in_walking_range(cell_under_pointer):
			overlay_manager.spawn_attackable_overlays(selected_unit.get_attack_pattern(), cell_under_pointer)
		
func handle_mouse_click(event : InputEventMouseButton):
	if event.button_index == 1 and event.pressed:
		var grid_cell : Vector2i = grid.get_grid_cell_under_pointer()
		
		if (is_unit_clicked(grid_cell)):
			handle_unit_clicked(entity_manager.get_unit_at_position(grid_cell))
			return
			
		if(grid.is_grid_position_in_bounds(grid_cell) == false):
			handle_click_outside_map()
			return
		
		handle_tile_map_click(grid_cell)
		
func handle_unit_clicked(unit : Unit):
	if(selected_unit == unit):
		return
	selected_unit = unit
	highlight_selected_unit()
	overlay_manager.spawn_walkable_overlays(selected_unit.get_movement_pattern(), grid.local_to_map(selected_unit.position))
	
func highlight_selected_unit():
	if(selected_unit == null):
		push_error("Tried to highlight a unit, but no unit selected.")
	unit_selection_indicator.visible = true
	unit_selection_indicator.position = selected_unit.position

func draw_movement_pattern():
	print(selected_unit.get_movement_pattern())
	
func try_unselect_unit():
	selected_unit = null
	unit_selection_indicator.visible = false
	overlay_manager.despawn_all_overlays()
		
func handle_click_outside_map():
	try_unselect_unit()
	
func handle_tile_map_click(coordinates : Vector2i):
	if(selected_unit != null):
		if(overlay_manager.spawned_walkable_overlays.has(coordinates)):
			move_selected_unit(grid.world_to_grid(selected_unit.position), coordinates)
	try_unselect_unit()
	
func move_selected_unit(from : Vector2i, to : Vector2i):
	selected_unit.move_to_grid_position(to)
	
func is_unit_clicked(map_coordinate : Vector2i):
	return entity_manager.get_unit_at_position(map_coordinate) != null

func spawn_unit(grid_sapwn_position : Vector2i):
	var unit_start_position = grid.map_to_local(grid_sapwn_position)
	var unit = test_unit.instantiate() as Unit
	grid.add_child(unit)
	unit.position = unit_start_position
	entity_manager.update_unit_position(unit, grid_sapwn_position)


