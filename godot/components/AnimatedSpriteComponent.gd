extends BaseComponent
class_name AnimatedSprite

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	component_name = Constants.EntityComponent.Animated_Sprite
	super._ready()
	animated_sprite.play("idle")

func _register_self():
	entity.register_component(component_name, animated_sprite)
