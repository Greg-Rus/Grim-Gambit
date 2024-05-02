extends Sprite2D

func _ready():
	EventBuss.unit_selected.connect(on_unit_selected)
	EventBuss.unit_unselected.connect(on_unit_selected)
	
func on_unit_selected(unit : Unit):
	position = unit.position
	visible = true
	
func on_unit_unselectes():
	visible = false
