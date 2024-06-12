extends Node
class_name Constants

enum MusicTracks {None, Menu, DungeonAmbience, Combat}
enum TileType {
	Wall = 0,
	Ground = 1
}
enum Pattern {Pawn, Rook, Bishop, Knight, Queen}

enum EntityComponent {None, Health, Movement, Attack, Animated_Sprite}
enum EntityCondition {Dead, Obstacle, Enemy, Player_Unit}

static var Pattern_Pawn : Array = [Vector2i.UP]
static var Pattern_Rook : Array = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
static var Pattern_Bishop : Array = [Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]
static var Pattern_Knight : Array =[Vector2i(1,-2), Vector2i(2,-1), Vector2i(2,1), Vector2i(1,2), \
							 		Vector2i(-1,2), Vector2i(-2,1), Vector2i(-2,-1), Vector2i(-1,-2)]
static var Pattern_Queen : Array = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT, \
									Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]

static func get_pattern_data(pattern_name : Pattern) -> Array:
	match pattern_name:
		Pattern.Pawn	: return Pattern_Pawn
		Pattern.Rook	: return Pattern_Rook
		Pattern.Bishop	: return Pattern_Bishop
		Pattern.Knight	: return Pattern_Knight
		Pattern.Queen	: return Pattern_Queen
		_ : return Pattern_Pawn
