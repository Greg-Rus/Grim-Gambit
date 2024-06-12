extends Node
class_name UnitSpawner

@onready var test_unit : PackedScene = preload("res://units/test_skeleton.tscn")
@onready var test_enemy : PackedScene = preload("res://units/test_unit.tscn")

func _ready():
	ServiceLocator.unit_spawner = self

func spawn_entity(prefab : PackedScene, grid_sapwn_position : Vector2i) -> Entity:
	var entity = prefab.instantiate() as Entity
	ServiceLocator.grid_manager.add_child(entity)
	entity.initialize(grid_sapwn_position)
	return entity

func spawn_custom_unit(spawn_coordinate : Vector2i, attack_pattern:Constants.Pattern, attack_range: int, move_pattern:Constants.Pattern, move_range:int):
	var unit = spawn_entity(test_unit, spawn_coordinate)
	var move = unit.get_component(Constants.EntityComponent.Movement) as MovementComponent
	move.movement_pattern = move_pattern
	move.movement_distance = move_range
	var attack = unit.get_component(Constants.EntityComponent.Attack) as AttackComponent
	attack.attack_pattern = attack_pattern
	attack.attack_range = attack_range
	unit.add_condition(Constants.EntityCondition.Player_Unit)
