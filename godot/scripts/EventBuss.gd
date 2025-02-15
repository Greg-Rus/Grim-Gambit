extends Node

signal unit_selected(unit:Entity)
signal unit_unselected()
signal unit_animating(is_animating:bool)
signal entity_changed_cell(entity : Entity)

signal pointer_cell_changed(new_cell : Vector2i)
signal pointer_click_cell(clicked_cell : Vector2i)
signal enemy_selected(enemy : Entity)
signal corpse_selected(enemy : Entity)
signal ground_tile_selected(coordiantes : Vector2i)
