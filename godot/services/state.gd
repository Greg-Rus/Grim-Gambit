extends Node

var selected_unit : Entity
var selected_corpse : Entity
var cell_under_pointer : Vector2i = Vector2i.MIN
var walkable_cells : Array
var attackable_cells : Array
