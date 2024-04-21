extends Node
class_name Constants

enum MusicTracks {None, Menu, DungeonAmbience, Combat}
enum TileType {
	Wall = 0,
	Ground = 1
}
enum MovementPattern {Pawn, Rook, Bishop, Knight}

static var Movement_Pawn : Array = [Vector2.UP]
static var Movement_Rook : Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
static var Movement_Bishop : Array = [Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]
static var Movement_Knight : Array =[Vector2(1,-2), Vector2(2,-1), Vector2(2,1), Vector2(1,2), \
							  Vector2(-1,2), Vector2(-2,1), Vector2(-2,-1), Vector2(-1,-2)]
							
static func get_move_pattern_data(pattern_name : MovementPattern) -> Array:
	match pattern_name:
		MovementPattern.Pawn	: return Movement_Pawn
		MovementPattern.Rook	: return Movement_Rook
		MovementPattern.Bishop	: return Movement_Bishop
		MovementPattern.Knight	: return Movement_Knight
		_ : return Movement_Pawn
