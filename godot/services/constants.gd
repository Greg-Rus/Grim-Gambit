extends Node
class_name Constants

enum MusicTracks {None, Menu, DungeonAmbience, Combat}
enum TileType {
	Wall = 0,
	Ground = 1
}
enum MovementPattern {Pawn, Rook, Bishop, Knight}

static var Movement_Pawn : Array = [Vector2i.UP]
static var Movement_Rook : Array = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
static var Movement_Bishop : Array = [Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]
static var Movement_Knight : Array =[Vector2i(1,-2), Vector2i(2,-1), Vector2i(2,1), Vector2i(1,2), \
							  Vector2i(-1,2), Vector2i(-2,1), Vector2i(-2,-1), Vector2i(-1,-2)]
							
static func get_pattern_data(pattern_name : MovementPattern) -> Array:
	match pattern_name:
		MovementPattern.Pawn	: return Movement_Pawn
		MovementPattern.Rook	: return Movement_Rook
		MovementPattern.Bishop	: return Movement_Bishop
		MovementPattern.Knight	: return Movement_Knight
		_ : return Movement_Pawn
