extends Node2D
class_name Entity

@export var conditions : Array[Constants.EntityCondition] = []
@export var cell: Vector2i

var components = {}

func initialize(spawn_cell:Vector2i):
	cell = spawn_cell
	EventBuss.entity_changed_cell.emit(self)
	position = Grid.instance.map_to_local(cell)
	print("cell: " + str(cell) + " pos: " + str(position))

func register_component(component_name:Constants.EntityComponent, component):
	components[component_name] = component

func get_component(component_name:Constants.EntityComponent):
	if(components.has(component_name)):
		return components[component_name]
	else:
		return null

func add_condition(condition : Constants.EntityCondition):
	if conditions.has(condition):
		return
	conditions.append(condition)

func remove_condition(condition : Constants.EntityCondition):
	if conditions.has(condition) == false:
		return
	conditions.erase(condition)
