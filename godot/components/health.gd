extends BaseComponent
class_name HealthComponent

@export var health : int = 1

func _ready():
	component_name = Constants.EntityComponent.Health
	super._ready()

func _register_self():
	entity.register_component(component_name, self)

func take_damage(damage:int):
	health -= damage
	if(health <= 0):
		var animator = entity.get_component(Constants.EntityComponent.Animated_Sprite)
		animator.play("die")
		entity.add_condition(Constants.EntityCondition.Dead)

func resurrect():
	health = 1
	entity.remove_condition(Constants.EntityCondition.Dead)
