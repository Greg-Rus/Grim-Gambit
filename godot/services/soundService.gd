extends Node

@onready var musicPlayer : AudioStreamPlayer = $Music
@onready var ambiencePlayer : AudioStreamPlayer = $Ambience

@export var menuMusic : AudioStream
@export var dungeonAmbiencee : AudioStream
@export var combatMusic : AudioStream

var currentMusicTrack : Constants.MusicTracks = Constants.MusicTracks.None

func play_music(track : Constants.MusicTracks):
	if(track == currentMusicTrack):
		return
	musicPlayer.stream = getMusicTrack(track)
	musicPlayer.play()
	currentMusicTrack = track
	
func getMusicTrack(track : Constants.MusicTracks) -> AudioStream:
	match track:
		Constants.MusicTracks.Menu:
			return menuMusic
		Constants.MusicTracks.DungeonAmbience:
			return dungeonAmbiencee
		Constants.MusicTracks.Combat:
			return combatMusic
		_: return null
