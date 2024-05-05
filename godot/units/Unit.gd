extends AnimatedSprite2D
class_name Unit

@export var movement_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var movement_distance : int = 1
@export var attack_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var attack_range : int = 1
@export var is_player_controled : bool = true
@export var is_alive : bool = true
@export var move_speed : float = 60
var tween : Tween
var grid_position: Vector2i

var is_animating:
	get: return tween != null
	
func _ready():
	play("idle")

func set_unit_position(grid_coordinates : Vector2i):
	grid_position = grid_coordinates
	position = Grid.instance.grid_to_world(grid_coordinates)
	EntityManager.instance.update_unit_position(self, grid_position)

func move_to_grid_position(grid_coordinates : Vector2i):
	animate_move(grid_coordinates)

func attack_unit(enemy : Unit):
	animate_attack(enemy)

func get_movement_pattern() -> Array:
	return Constants.get_pattern_data(movement_pattern)

func get_attack_pattern() -> Array:
	var pattern_positions = []
	var pattern = Constants.get_pattern_data(attack_pattern)
	for i in range(1, attack_range + 1):
		for pattern_position in pattern:
			pattern_positions.append(pattern_position * i)
	return pattern_positions

func make_new_tween():
	if(tween != null):
		tween.kill()
		tween = null
	tween = get_tree().create_tween()

func animate_move(destination : Vector2i):
	var final_position : Vector2 = Grid.instance.grid_to_world(destination)
	var move_distance = (final_position - position).length()
	var move_duration = move_distance / move_speed
	try_flip_towards(destination)
	make_new_tween()
	tween = get_tree().create_tween()
	tween.tween_callback(func(): EventBuss.unit_animating.emit(true))
	tween.tween_callback(func(): play("walk"))
	tween.tween_property(self, "position", final_position, move_duration)
	tween.tween_callback(func(): EventBuss.unit_animating.emit(false))
	tween.tween_callback(func(): stop())
	tween.tween_callback(func(): on_arrived_at_destination(destination))

func on_arrived_at_destination(destination:Vector2i):
	set_unit_position(destination)
	tween = null

func animate_attack(enemy : Unit):
	var target_cell_position = Grid.instance.grid_to_world(enemy.grid_position)
	var direction_to_destionation = (target_cell_position - position)
	var target_position = position + direction_to_destionation * 0.5
	var start_position = position
	try_flip_towards(enemy.grid_position)
	make_new_tween()
	tween.tween_callback(func(): EventBuss.unit_animating.emit(true))
	tween.tween_property(self, "position", target_position, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): attack_hit(enemy))
	tween.tween_property(self, "position", start_position, 0.4)
	tween.tween_callback(func(): attack_complete(enemy))
	
func attack_hit(enemy : Unit):
	enemy.die()

func attack_complete(enemy : Unit):
	EventBuss.unit_animating.emit(false)
	tween = null
	
func try_flip_towards(target_cell:Vector2i):
	var direction = target_cell - grid_position
	flip_h = direction.x < 0
	
func die():
	play("die")
	await animation_finished
	is_alive = false
	EntityManager.instance.destroy_unit(self)
