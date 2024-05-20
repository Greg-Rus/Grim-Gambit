extends Node2D
class_name EntityManager

static var instance : EntityManager

func _ready():
	if(instance == null):
		instance = self
	EventBuss.entity_changed_cell.connect(update_entity_cell)

var entity_to_cell = {}
var cell_to_entity = {}

var selected_unit : Entity

func select_unit(entity : Entity):
	selected_unit = entity
	EventBuss.unit_selected.emit(selected_unit)
	
func unselect_unit():
	selected_unit = null
	EventBuss.unit_unselected.emit()
	
func is_unit_selected() -> bool:
	return selected_unit != null
	
func update_entity_cell(entity : Entity):
	var new_cell = entity.cell
	if(entity_to_cell.has(entity)):
		var old_cell = entity_to_cell[entity]
		entity_to_cell.erase(entity)
		cell_to_entity.erase(old_cell)
	entity_to_cell[entity] = new_cell
	cell_to_entity[new_cell] = entity
		
func get_entity_position(entity : Entity) -> Vector2i:
	if entity_to_cell.has(entity):
		return entity_to_cell[entity]
	else:
		printerr("Unit not in entity manager", entity)
		return Vector2i.MIN
	
func get_entity_at_position(grid_position : Vector2i) -> Entity:
	if cell_to_entity.has(grid_position):
		return cell_to_entity[grid_position]
	return null
