extends BaseComponent
class_name AnimatedSprite

@onready var AnimatedSprite : AnimatedSprite2D = $AnimatedSprite2D

func _register_self():
	entity.register_component(component_name, AnimatedSprite)
