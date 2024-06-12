extends Sprite2D

func _ready():
	EventBuss.unit_selected.connect(on_unit_selected)
	EventBuss.unit_unselected.connect(on_unit_unselected)
	EventBuss.corpse_selected.connect(on_unit_selected)
	
func on_unit_selected(unit : Entity):
	position = unit.position
	visible = true
	
func on_unit_unselected():
	visible = false
