extends Node2D
class_name OveralyManager

@onready var grid : Grid = %TileMap
@onready var entity_manager : EntityManager = %EntityManager
@onready var walkable_overlay : PackedScene = preload("res://nodes/tile_overlay.tscn")
@onready var attackable_overlay : PackedScene = preload("res://nodes/tile_overlay_attack.tscn")

var spawned_walkable_overlays : Array = []
var spawned_attackable_overlays : Array = []
var attack_pattern_origin : Vector2i = Vector2i.MAX

func _ready():
	ServiceLocator.overlay_manager = self
	EventBuss.unit_unselected.connect(despawn_all_overlays)

func spawn_walkable_overlays(positions : Array):
	for position in positions:
		var overlay = walkable_overlay.instantiate() as Node2D
		overlay.position = grid.grid_to_world(position)
		add_child(overlay)
		spawned_walkable_overlays.append(overlay) 
			
func spawn_attackable_overlays(positions : Array):
	despawn_attackable_overlays()
	for position in positions:
		var overlay = attackable_overlay.instantiate() as Node2D
		overlay.position = grid.grid_to_world(position)
		add_child(overlay)
		spawned_attackable_overlays.append(overlay) 
			
func despawn_all_overlays():
	despawn_wlakable_overlays()
	despawn_attackable_overlays()

func despawn_wlakable_overlays():
	for overlay in spawned_walkable_overlays:
		(overlay as Node2D).queue_free()
	spawned_walkable_overlays.clear()
	
func despawn_attackable_overlays():
	for overlay in spawned_attackable_overlays:
		(overlay as Node2D).queue_free()
	spawned_attackable_overlays.clear()
	attack_pattern_origin = Vector2i.MAX
