extends BaseCommand
class_name MoveCommand

var _entity : Entity
var _destination : Vector2i

func setup(entity:Entity, destination:Vector2i) -> MoveCommand:
	_entity = entity
	_destination = destination
	return self

func execute():
	var move_component = _entity.get_component(Constants.EntityComponent.Movement) as MovementComponent
	move_component.animate_move(_destination)
