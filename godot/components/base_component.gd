extends Node2D
class_name BaseComponent

var entity : Entity
@export var component_name : Constants.EntityComponent = Constants.EntityComponent.None

func _ready():
	entity = get_parent()
	if(entity == null):
		push_error("Component " + str(component_name) + " failed to find the parent Entity")
	_register_self()

func _register_self():
	push_error("No registration logic for component" + str(component_name))
