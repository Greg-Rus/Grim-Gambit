extends Node2D
class_name WorldManager

@export var room_dimensions : Vector2i = Vector2i(8,8)

@onready var room_builder : RoomBuilder = %RoomBuilder
@onready var grid : Grid = %TileMap
@onready var test_unit : PackedScene = preload("res://units/test_skeleton.tscn")
@onready var test_enemy : PackedScene = preload("res://units/test_unit.tscn")
@onready var overlay_manager : OveralyManager = %OverlayManager
@onready var entity_manager : EntityManager = %EntityManager
var cell_pixel_size = 16
var room_offset : Vector2
var grid_dimensions : Vector2i
	
func _ready():
	grid_dimensions = room_dimensions - Vector2i.ONE
	var screen_center = get_viewport_rect().size * 0.5
	room_offset = screen_center + Vector2(room_dimensions) * 0.5 * cell_pixel_size * -1

	room_builder.make_room(room_dimensions, room_offset)
	var player_unit_position = Vector2i(grid_dimensions.x/2, grid_dimensions.y)
	var player_unit = spawn_entity(test_unit, player_unit_position)
	player_unit.conditions.append(Constants.EntityCondition.Player_Unit)
	spawn_random_enemies()

func _input(event):
	#if entity_manager.is_unit_selected():
		#handle_mouse_move()
	if event is InputEventMouseButton:
		handle_mouse_click(event)
		
func spawn_random_enemies():
	for i in 8:
		var x = randi_range(0, grid_dimensions.x)
		var y = randi_range(0, grid_dimensions.y)
		var enemy_unit_position = Vector2i(x,y)
		if(entity_manager.get_entity_at_position(enemy_unit_position) == null):
			var enemy : Entity = spawn_entity(test_enemy, enemy_unit_position)
			enemy.conditions.append(Constants.EntityCondition.Enemy)
		
func handle_mouse_move():
	var cell_under_pointer : Vector2i = grid.get_grid_cell_under_pointer()
	if grid.is_grid_position_in_bounds(cell_under_pointer):
		if overlay_manager.is_in_walking_range(cell_under_pointer) || \
		cell_under_pointer == State.selected_unit.cell:
			overlay_manager.spawn_attackable_overlays(State.selected_unit)
		
func handle_mouse_click(event : InputEventMouseButton):
	if event.button_index == 1 and event.pressed:
		var grid_cell : Vector2i = grid.get_grid_cell_under_pointer()
		
		if (is_unit_clicked(grid_cell)):
			handle_unit_clicked(entity_manager.get_entity_at_position(grid_cell))
			return
			
		if (is_enemy_clicked(grid_cell)):
			handle_enemy_clicked(entity_manager.get_entity_at_position(grid_cell))
			return
			
		if(grid.is_grid_position_in_bounds(grid_cell) == false):
			handle_click_outside_map()
			return
		
		handle_tile_map_click(grid_cell)
		
func handle_unit_clicked(unit : Entity):
	if(State.selected_unit == unit):
		return
	entity_manager.select_unit(unit)
		
func handle_enemy_clicked(entity : Entity):
	if entity_manager.is_unit_selected() == false:
		return
	if overlay_manager.is_in_attack_range(entity.cell):
		var attack = State.selected_unit.get_component(Constants.EntityComponent.Attack) as AttackComponent
		attack.animate_attack(entity)
		entity_manager.unselect_unit()
		
func handle_click_outside_map():
	entity_manager.unselect_unit()
	
func handle_tile_map_click(coordinates : Vector2i):
	if entity_manager.is_unit_selected():
		if(overlay_manager.spawned_walkable_overlays.has(coordinates)):
			move_selected_unit(grid.world_to_grid(State.selected_unit.position), coordinates)
	entity_manager.unselect_unit()
	
func move_selected_unit(from : Vector2i, to : Vector2i):
	MoveCommand.new().setup(State.selected_unit, to).execute()
	
func is_unit_clicked(map_coordinate : Vector2i):
	var entity : Entity = entity_manager.get_entity_at_position(map_coordinate)
	return entity != null && entity.conditions.has(Constants.EntityCondition.Player_Unit)
	
func is_enemy_clicked(map_coordinate : Vector2i):
	var entity : Entity = entity_manager.get_entity_at_position(map_coordinate)
	return entity != null && entity.conditions.has(Constants.EntityCondition.Enemy)

func spawn_entity(prefab : PackedScene, grid_sapwn_position : Vector2i) -> Entity:
	var entity = prefab.instantiate() as Entity
	grid.add_child(entity)
	entity.initialize(grid_sapwn_position)
	return entity


