extends Node
var dices_used = 0
var FULLSCREEN = false
var Temardo = null
var ShakeSFX = null
var RollSFX = null
var DiceclickSFX = null
var ScoreSFX = null
var ClickSFX = null
var shaker_obj = null

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

enum DiceIDs {
	Normal,
	Loaded,
	PlusDice,
	MultDice,
	Copy,
	D2,
	D3,
	TurnPlus,
	Rubber,
	MultDice2,
}

var DiceTypes = {
	Normal = {"id": DiceIDs.Normal, "price": 0, "texture": load("res://sprites/dices/cube1.png"), "title": "Dado normal", "description": "Confiable dado de [color=red] 6[/color] lados."},
	Loaded = {"id": DiceIDs.Loaded, "price": 10, "texture": load("res://sprites/dices/loaded.png"), "title": "Dado cargado", "description": "Siempre sale un [color=red] 6[/color]."},
	PlusDice = {"id": DiceIDs.PlusDice, "price": 6, "texture": load("res://sprites/dices/plusdice.png"), "title": "Dado plus", "description": "[color=red]Suma[/color] su valor al puntaje."},
	MultDice = {"id": DiceIDs.MultDice, "price": 150, "texture": load("res://sprites/dices/muldice.png"), "title": "Dado multiplicador", "description": "[color=red]Multiplica[/color] el puntaje por su valor."},
	MultDice2 = {"id": DiceIDs.MultDice2, "price": 10, "texture": load("res://sprites/dices/muldice2.png"), "title": "Dado x2", "description": "[color=red]Multiplica[/color] el puntaje por [color=red] 2[/color]."},
	
	Copy = {"id": DiceIDs.Copy, "price": 10, "texture": load("res://sprites/dices/copy.png"), "title": "Dado copion", "description": "[color=red]Copia[/color] el valor de otro dado al azar."},
	D2 = {"id": DiceIDs.D2, "price": 7, "texture": load("res://sprites/dices/dx2.png"), "title": "Dado D2", "description": "Solo tiene [color=red] 2[/color] valores."},
	D3 = {"id": DiceIDs.D3, "price": 5, "texture": load("res://sprites/dices/dx3.png"), "title": "Dado D3", "description": "Solo tiene [color=red] 3[/color] valores."},
	TurnPlus = {"id": DiceIDs.TurnPlus, "price": 3, "texture": load("res://sprites/dices/turnplus.png"), "title": "Dado +1 Turno", "description": "Tener este dado suma [color=red] 1[/color] turno la partida."},
	Rubber = {"id": DiceIDs.Rubber, "price": 5, "texture": load("res://sprites/dices/rubber.png"), "title": "Dado de goma", "description": "Al tirarlo permite un [color=red] flip[/color] a su lado opuesto."},
}

var DiceChances = [
	DiceTypes.Loaded, 
	DiceTypes.PlusDice, 
	DiceTypes.MultDice, 
	DiceTypes.Copy, 
	DiceTypes.D2, 
	DiceTypes.D3, 
	DiceTypes.TurnPlus, 
	DiceTypes.Rubber,
	DiceTypes.MultDice2,
]

var DiceChancesTmp = []

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
var Goals = [0, 45, 100, 120, 150, 250, 800, 1000, 2000]
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
	refreshPool(true)
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
		
func refreshPool(reroll = false):
	DiceChancesTmp = [] + DiceChances
	if reroll:
		var dices = get_tree().get_nodes_in_group("diceshop")
		for d in dices:
			d.randomize_dice()
		
		
func gameover(win):
	if !win:
		Global.point_list.fade_in()
		Global.GameOver = true

func minforTurn():
	if Global.Beaker.first:
		return 5
	else:
		return 1
		
func getDiceExtraText(DiceType, currentvalue):
	if DiceType == Global.DiceTypes.MultDice:
		return "X" + str(currentvalue)
	elif DiceType == Global.DiceTypes.PlusDice:
		return "+" + str(currentvalue)
	elif DiceType == Global.DiceTypes.MultDice2:
		return "X" + str(2)
	else:
		return ""
	
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
