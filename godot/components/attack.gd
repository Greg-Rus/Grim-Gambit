extends BaseComponent
class_name AttackComponent

@export var attack_pattern : Constants.MovementPattern = Constants.MovementPattern.Pawn
@export var attack_range : int = 1
@export var damage : int = 1

var tween : Tween

func _ready():
	component_name = Constants.EntityComponent.Attack
	super._ready()

func _register_self():
	entity.register_component(component_name, self)
	
func get_attack_pattern() -> Array:
	var pattern_positions = []
	var pattern = Constants.get_pattern_data(attack_pattern)
	for i in range(1, attack_range + 1):
		for pattern_position in pattern:
			pattern_positions.append(pattern_position * i)
	return pattern_positions

func animate_attack(enemy : Entity):
	var enemy_position = Grid.instance.map_to_local(enemy.cell)
	var direction_to_enemy = (enemy_position - entity.position)
	var target_position = entity.position + direction_to_enemy * 0.5
	var start_position = entity.position
	
	try_flip_towards(enemy.cell)
	
	if(tween != null):
		tween.kill()
		tween = null
	tween = get_tree().create_tween()
	tween.tween_callback(func(): EventBuss.unit_animating.emit(true))
	tween.tween_property(entity, "position", target_position, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): attack_hit(enemy))
	tween.tween_property(entity, "position", start_position, 0.4)
	tween.tween_callback(func(): attack_complete())
	
func attack_hit(enemy : Entity):
	#if enemy.has_component(Constants.EntityComponent.Health):
	var enemy_health = enemy.get_component(Constants.EntityComponent.Health) as HealthComponent
	enemy_health.take_damage(damage)

func attack_complete():
	EventBuss.unit_animating.emit(false)
	tween = null

func try_flip_towards(target_cell:Vector2i):
	var direction = target_cell - entity.cell
	get_animated_sprite().flip_h = direction.x < 0
	
func get_animated_sprite():
	return entity.get_component(Constants.EntityComponent.Animated_Sprite) as AnimatedSprite2D
