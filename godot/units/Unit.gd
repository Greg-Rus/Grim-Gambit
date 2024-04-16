extends AnimatedSprite2D
class_name Unit

#func _on_area_2d_input_event(_viewport, event : InputEvent, _shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == 1 && event.pressed:
			#print("click")
