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
		
func spawn_random_enemies():
	for i in 8:
		var x = randi_range(0, grid_dimensions.x)
		var y = randi_range(0, grid_dimensions.y)
		var enemy_unit_position = Vector2i(x,y)
		if(entity_manager.get_entity_at_position(enemy_unit_position) == null):
			var enemy : Entity = spawn_entity(test_enemy, enemy_unit_position)
			enemy.conditions.append(Constants.EntityCondition.Enemy)

func spawn_entity(prefab : PackedScene, grid_sapwn_position : Vector2i) -> Entity:
	var entity = prefab.instantiate() as Entity
	grid.add_child(entity)
	entity.initialize(grid_sapwn_position)
	return entity
