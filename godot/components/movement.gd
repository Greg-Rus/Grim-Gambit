extends BaseComponent
class_name MovementComponent

@export var movement_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var movement_distance : int = 1
@export var movement_animation_speed : float = 60

var tween : Tween

func _ready():
	component_name = Constants.EntityComponent.Movement
	super._ready()

func _register_self():
	entity.register_component(component_name, self)

func get_movement_pattern() -> Array:
	return Constants.get_pattern_data(movement_pattern)

func animate_move(destination : Vector2i):
	var final_position : Vector2 = Grid.instance.grid_to_world(destination)
	var move_distance = (final_position - entity.position).length()
	var move_duration = move_distance / movement_animation_speed
	try_flip_towards(destination)
	
	if(tween != null):
		tween.kill()
		tween = null
	tween = get_tree().create_tween()
	tween.tween_callback(func(): EventBuss.unit_animating.emit(true))
	tween.tween_callback(start_animation)
	tween.tween_property(entity, "position", final_position, move_duration)
	tween.tween_callback(func(): EventBuss.unit_animating.emit(false))
	tween.tween_callback(end_animation)
	tween.tween_callback(func(): on_arrived_at_destination(destination))
	
func start_animation():
	get_animated_sprite().play("walk")
	
func end_animation():
	get_animated_sprite().stop()

func try_flip_towards(target_cell:Vector2i):
	var direction = target_cell - entity.cell
	get_animated_sprite().flip_h = direction.x < 0
	
func on_arrived_at_destination(destination:Vector2i):
	entity.cell = destination
	EventBuss.entity_changed_cell.emit(entity)
	tween = null
	
func get_animated_sprite():
	return entity.get_component(Constants.EntityComponent.Animated_Sprite) as AnimatedSprite2D
