extends CanvasLayer
class_name UnitSelectionPanel

@onready var attack_pattenrn_bishop_button	: Button = $Panel/AttackPatternButtons/Bishop
@onready var attack_pattenrn_knight_button	: Button = $Panel/AttackPatternButtons/Knight
@onready var attack_pattenrn_rook_button	: Button = $Panel/AttackPatternButtons/Rook
@onready var attack_pattenrn_queen_button	: Button = $Panel/AttackPatternButtons/Queen
@onready var attack_pattenrn_range_increase	: Button = $Panel/AttackRangeButtons/Plus
@onready var attack_pattenrn_range_decrease	: Button = $Panel/AttackRangeButtons/Minus
@onready var attack_range_label				: Label =  $Panel/AttackRangeButtons/Label

@onready var move_pattenrn_bishop_button 	: Button = $Panel/MovePatternButtons/Bishop
@onready var move_pattenrn_knight_button 	: Button = $Panel/MovePatternButtons/Knight
@onready var move_pattenrn_rook_button		: Button = $Panel/MovePatternButtons/Rook
@onready var move_pattenrn_queen_button 	: Button = $Panel/MovePatternButtons/Queen
@onready var move_pattenrn_range_increase	: Button = $Panel/MoveRangeButtons/Plus
@onready var move_pattenrn_range_decrease 	: Button = $Panel/MoveRangeButtons/Minus
@onready var move_range_label 				: Label =  $Panel/MoveRangeButtons/Label

@onready var cast_buton						: Button = $Panel/CastButton

var selected_move_pattern : Constants.Pattern
var selected_move_range : int = 1
var selected_attack_pattern : Constants.Pattern
var selected_attack_range : int = 1

func _ready():
	attack_pattenrn_bishop_button.pressed.connect(func(): on_attack_button(Constants.Pattern.Bishop))
	attack_pattenrn_knight_button.pressed.connect(func(): on_attack_button(Constants.Pattern.Knight))
	attack_pattenrn_rook_button.pressed.connect(func(): on_attack_button(Constants.Pattern.Rook))
	attack_pattenrn_queen_button.pressed.connect(func(): on_attack_button(Constants.Pattern.Queen))
	attack_pattenrn_range_increase.pressed.connect(func(): on_attack_range_change(1))
	attack_pattenrn_range_decrease.pressed.connect(func(): on_attack_range_change(-1))
	
	move_pattenrn_bishop_button.pressed.connect(func(): on_movement_button(Constants.Pattern.Bishop))
	move_pattenrn_knight_button.pressed.connect(func(): on_movement_button(Constants.Pattern.Knight))
	move_pattenrn_rook_button.pressed.connect(func(): on_movement_button(Constants.Pattern.Rook))
	move_pattenrn_queen_button.pressed.connect(func(): on_movement_button(Constants.Pattern.Queen))
	move_pattenrn_range_increase.pressed.connect(func(): on_move_range_change(1))
	move_pattenrn_range_decrease.pressed.connect(func(): on_move_range_change(-1))
	
	cast_buton.pressed.connect(on_cast)
	update_ui()

func on_attack_button(pattern : Constants.Pattern):
	selected_attack_pattern = pattern
	
func on_movement_button(pattern : Constants.Pattern):
	selected_move_pattern = pattern
	
func on_attack_range_change(delta : int):
	selected_attack_range += delta
	update_ui()
	
func on_move_range_change(delta : int):
	selected_move_range += delta
	update_ui()

func update_ui():
	attack_range_label.text = str(selected_attack_range)
	move_range_label.text = str(selected_move_range)
	
func on_cast():
	print("Casting: Attack = " + str(Constants.Pattern.find_key(selected_attack_pattern))+"["+str(selected_attack_range)+"]" + " Move = " + str(Constants.Pattern.find_key(selected_move_pattern))+"["+str(selected_move_range)+"]")
	if State.selected_corpse == null:
		print("No corpse selected")
		reset()
	else:
		var corpse = State.selected_corpse as Entity
		var position = corpse.cell
		State.selected_corpse = null
		EventBuss.unit_unselected.emit()
		ServiceLocator.entity_manager.remove_entity(corpse)
		ServiceLocator.unit_spawner.spawn_custom_unit(position, selected_attack_pattern, selected_attack_range, selected_move_pattern, selected_move_range)
	
func reset():
	selected_attack_range = 0
	selected_move_range = 0
	update_ui()
