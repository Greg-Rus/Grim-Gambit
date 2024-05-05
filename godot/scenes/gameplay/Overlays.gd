extends Node2D
class_name OveralyManager

@onready var grid : Grid = %TileMap
@onready var entity_manager : EntityManager = %EntityManager
@onready var walkable_overlay : PackedScene = preload("res://nodes/tile_overlay.tscn")
@onready var attackable_overlay : PackedScene = preload("res://nodes/tile_overlay_attack.tscn")

var spawned_walkable_overlays = {}
var spawned_attackable_overlays = {}
var attack_pattern_origin : Vector2i = Vector2i.MAX

func _ready():
	EventBuss.unit_unselected.connect(despawn_all_overlays)
	EventBuss.unit_selected.connect(on_unit_selected)
	
func on_unit_selected(unit:Unit):
	detect_walkable_cells(unit)
	spawn_walkable_overlays(unit.get_movement_pattern(), unit.grid_position)
	spawn_attackable_overlays(unit.get_attack_pattern(), unit.grid_position)
	
func detect_walkable_cells(unit:Unit):
	var pattern = unit.get_attack_pattern()
	var range = unit.movement_distance
	var illegal_positions = []
	for i in range(1, range + 1):
		for position in pattern:
			if(illegal_positions.has(position)):
				continue
			var move_position = unit.grid_position + (position * i)
			if(is_walkable(move_position)):
				spawned_walkable_overlays[move_position] = null
			else:
				illegal_positions.append(position)
				

func spawn_walkable_overlays(moves : Array, grid_position : Vector2i):
	for position in spawned_walkable_overlays.keys():
		var overlay = walkable_overlay.instantiate() as Node2D
		overlay.position = grid.grid_to_world(position)
		add_child(overlay)
		spawned_walkable_overlays[position] = overlay
			
func spawn_attackable_overlays(attacks : Array, grid_position : Vector2i):
	if(attack_pattern_origin == grid_position):
		return
	despawn_attackable_overlays()
	attack_pattern_origin = grid_position
	for attack in attacks:
		var attack_position = grid_position + attack
		if(is_attackable(attack_position)):
			var overlay = attackable_overlay.instantiate() as Node2D
			overlay.position = grid.grid_to_world(attack_position)
			add_child(overlay)
			spawned_attackable_overlays[attack_position] = overlay
			
func despawn_all_overlays():
	despawn_wlakable_overlays()
	despawn_attackable_overlays()

func despawn_wlakable_overlays():
	for overlay in spawned_walkable_overlays.values():
		(overlay as Node2D).queue_free()
	spawned_walkable_overlays.clear()
	
func despawn_attackable_overlays():
	for overlay in spawned_attackable_overlays.values():
		(overlay as Node2D).queue_free()
	spawned_attackable_overlays.clear()
	attack_pattern_origin = Vector2i.MAX
	
func is_walkable(coordinates:Vector2i) -> bool:
	return grid.is_cell_walkable(coordinates) && entity_manager.get_unit_at_position(coordinates) == null
	
func is_attackable(coordinates:Vector2i) -> bool:
	return grid.is_cell_walkable(coordinates)

func is_in_walking_range(coordinate:Vector2i) -> bool:
	return spawned_walkable_overlays.has(coordinate)
	
func is_in_attack_range(coordinate:Vector2i) -> bool:
	return spawned_attackable_overlays.has(coordinate)
