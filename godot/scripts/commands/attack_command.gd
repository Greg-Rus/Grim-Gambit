extends BaseCommand
class_name AttackCommand

var _unit : Entity
var _enemy : Entity

func setup(unit:Entity, enemy:Entity) -> AttackCommand:
	_unit = unit
	_enemy = enemy
	return self

func execute():
	var attack_componant = _unit.get_component(Constants.EntityComponent.Attack) as AttackComponent
	attack_componant.animate_attack(_enemy)
