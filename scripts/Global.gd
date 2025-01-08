extends Node
var dices_used = 0
var FULLSCREEN = false
var Temardo = null
var ShakeSFX = null
var RollSFX = null
var DiceclickSFX = null
var ScoreSFX = null
var ClickSFX = null

enum Statuses {
	IDLE,
	SHAKING,
	THROWING,
}

var Status = Statuses.IDLE

enum Games {
	ONE = 0,
	TWO = 1,
	THREE = 2,
	FOUR = 3,
	FIVE = 4,
	SIX = 5,
	DOUBLE = 6,
	FLUSH = 7,
	FULL = 8,
	POKER = 9,
	GENERALA = 10,
	GENERALA2 = 11,
}

var point_list = null
var points_normal = [null, null, null, null, null, null, 10, 20, 30, 40, 50, 100] 
var points_serve = [null, null, null, null, null, null, 15, 25, 35, 45, 55, 200] 
	
var Level = 1
var LevelMax = 8
var Turn = 1
var InternarlTurn = 1
var TurnMax = 7
var Points = 0
var Goal = 45
var Goals = [0, 45, 65, 85, 95, 100, 120, 150, 250]
var GameOver = false
var Beaker = null

func Next():
	Turn += 1
	InternarlTurn += 1
	if Turn > TurnMax:
		if Points < Goal:
			gameover(false)
		else:
			NextLevel()
			
func NextLevel():
	Level += 1
	if Level > LevelMax:
		gameover(true)
	else:
		Global.Beaker.first = true
		Global.Points = 0
		Global.Turn = 1
		Global.InternarlTurn = 1
		Global.point_list.next_level()
		Goal = Goals[Level]
		
func gameover(win):
	if !win:
		Global.point_list.fade_in()
		Global.GameOver = true

func minforTurn():
	if Global.Beaker.first:
		return 5
	else:
		return 1
	
func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY,
			TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_STRING_ARRAY,
			TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]
	

func play_sound(stream: AudioStream, options:= {}, _global_position = null) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
	
	audio_stream_player.play()
	audio_stream_player.finished.connect(kill.bind(audio_stream_player))
	
	return audio_stream_player
	
func kill(_audio_stream_player):
	if _audio_stream_player and is_instance_valid(_audio_stream_player):
		_audio_stream_player.queue_free()
