extends Node
var dices_used = 0
var FULLSCREEN = false
var Temardo = null
var ShakeSFX = null
var RollSFX = null
var DiceclickSFX = null
var ScoreSFX = null
var ClickSFX = null
var FlameSfx = null
var ButtonSFX = null
var BuySFX = null
var GlassSFX = null
var ShepardSFX = null
var VictorySFX = null
var shaker_obj = null
var RerollCost = 2
var particle = preload("res://scenes/particle2.tscn")
var preventSelect = false

enum Statuses {
	IDLE,
	SHAKING,
	THROWING,
	WARPING,
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
	OneMoreChance,
	Cheese,
	Hologram,
	Fake,
}

var DiceTypes = {
	Normal = {"id": DiceIDs.Normal, "price": 0, "texture": load("res://sprites/dices/cube1.png"), "title": "Dado normal", "description": "Confiable dado de [color=red] 6[/color] lados."},
	Loaded = {"id": DiceIDs.Loaded, "price": 10, "texture": load("res://sprites/dices/loaded.png"), "title": "Dado cargado", "description": "Siempre sale un [color=red] 6[/color]."},
	PlusDice = {"id": DiceIDs.PlusDice, "price": 6, "texture": load("res://sprites/dices/plusdice.png"), "title": "Dado plus", "description": "[color=red]Suma[/color] su valor al puntaje."},
	MultDice = {"id": DiceIDs.MultDice, "price": 50, "texture": load("res://sprites/dices/muldice.png"), "title": "Dado multiplicador", "description": "[color=red]Multiplica[/color] el puntaje por su valor."},
	MultDice2 = {"id": DiceIDs.MultDice2, "price": 10, "texture": load("res://sprites/dices/muldice2.png"), "title": "Dado x2", "description": "[color=red]Multiplica[/color] el puntaje por [color=red] 2[/color]."},
	
	Copy = {"id": DiceIDs.Copy, "price": 10, "texture": load("res://sprites/dices/copy.png"), "title": "El Copion", "description": "[color=red]Copia[/color] el valor de otro dado al azar."},
	D2 = {"id": DiceIDs.D2, "price": 7, "texture": load("res://sprites/dices/dx2.png"), "title": "Dado D2", "description": "Solo tiene [color=red] 2[/color] valores ([color=red]1, 2[/color])."},
	D3 = {"id": DiceIDs.D3, "price": 5, "texture": load("res://sprites/dices/dx3.png"), "title": "Dado D3", "description": "Solo tiene [color=red] 3[/color] valores ([color=red]1, 2, 3[/color])."},
	TurnPlus = {"id": DiceIDs.TurnPlus, "price": 3, "texture": load("res://sprites/dices/turnplus.png"), "title": "La vida", "description": "Tener este dado suma [color=red] 1[/color] turno la partida."},
	Rubber = {"id": DiceIDs.Rubber, "price": 5, "texture": load("res://sprites/dices/rubber.png"), "title": "Panqueque", "description": "Al tirarlo permite hacer [color=red] flip[/color] a su lado opuesto."},
	OneMoreChance = {"id": DiceIDs.OneMoreChance, "price": 10, "texture": load("res://sprites/dices/onemore.png"), "title": "El ensayo", "description": "No consume la jugada al usarlo. Al usarse se [color=red] agota[/color]."},
	Cheese = {"id": DiceIDs.Cheese, "price": 15, "texture": load("res://sprites/dices/cheese.png"), "title": "Quesito", "description": "Es un dado extra por fuera del [color=blue]cubilete[/color]. El dado extra se [color=red]agota[/color] siempre despues de la tirada."},
	Hologram = {"id": DiceIDs.Cheese, "price": 10, "texture": load("res://sprites/dices/hologram.png"), "title": "Holo-Dado", "description": "El dado proyecta un holograma de si mismo con identico [color=red]valor[/color]."},
	Fake = {"id": DiceIDs.Fake, "price": 0, "texture": load("res://sprites/dices/fake.png"), "title": "Fake", "description": "Fake"},
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
	DiceTypes.OneMoreChance,
	DiceTypes.Cheese,
	DiceTypes.Hologram,
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
var Goals = [0, 45, 90, 180, 195, 250, 500, 1000, 2000]
var Goal = Goals[1]
var GameOver = false
var Beaker = null

func _ready():
	Global.Temardo = preload("res://music/dados.wav")
	Global.ShakeSFX = preload("res://sfx/shaking.wav")
	Global.RollSFX = preload("res://sfx/roll.wav")
	Global.DiceclickSFX = preload("res://sfx/dice_click.wav")
	Global.ScoreSFX = preload("res://sfx/score.wav")
	Global.ClickSFX = preload("res://sfx/button_click.wav")
	Global.FlameSfx = preload("res://sfx/flamesfx.wav")
	Global.BuySFX = preload("res://sfx/buysfx.wav")
	Global.ButtonSFX = preload("res://sfx/buttonclick.wav")
	Global.GlassSFX = preload("res://sfx/glass.wav")
	Global.ShepardSFX = preload("res://sfx/shepard.wav")
	Global.VictorySFX = preload("res://sfx/victory.wav")

func Next(PointsShow = null):
	Turn += 1
	InternarlTurn += 1
	if Turn > TurnMax:
		if Points < Goal:
			PointsShow.hideme()
			gameover(false)
		else:
			NextLevel()
			
func NextLevel():
	refreshPool(true, true)
	Level += 1
	if Level > LevelMax:
		gameover(true)
	else:
		Global.Beaker.first = true
		var local_points = Goals[Level - 1]
		await points_to(local_points).finished
		Global.Turn = 1
		Global.InternarlTurn = 1
		Global.point_list.next_level()
		Goal = Goals[Level]
		
func points_to(points, _speed = 1.0):
	var _tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUINT)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(Global, "Points", points, _speed)
	return _tween
		
func refreshPool(reroll = false, restart = false):
	DiceChancesTmp = [] + DiceChances
	if reroll:
		var dices = get_tree().get_nodes_in_group("diceshop")
		for d in dices:
			if restart:
				d.available = true
				d.visible = true
			d.randomize_dice()
			
func uncopyAll():
	var dices = get_tree().get_nodes_in_group("dices")
	for d in dices:
		d.unCopyMe()
		
func getRandomDiceToCopy(me, DiceMan_dices):
	var dices_list = [] + DiceMan_dices
	dices_list.shuffle()
	for d in dices_list:
		if d != me and d.DiceType != Global.DiceTypes.Copy:
			return d
			
	return null
		
func gotoBase(DiceMan_dices, Mark1, Mark2, Mark3, Mark4, Mark5):
	var marks = [Mark1, Mark2, Mark3, Mark4, Mark5]
	var dices = get_tree().get_nodes_in_group("dices")
	for d in dices:
		if d not in DiceMan_dices:
			var m = marks.pop_front()
			await d.move_to(m.global_position).finished
			d.minigrow()
		
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
		
func emit(_global_position, count, particle_obj = null, size = 1):
	var part = particle
	if particle_obj:
		part = particle_obj
	
	for i in range(count):
		var p = part.instantiate()
		p.global_position = _global_position
		p.size = size
		add_child(p)
	
func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY,
			TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_STRING_ARRAY,
			TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]

func play_sound(stream: AudioStream, options:= {}, _global_position = null, delay = 0.0) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
		
	if delay > 0.0:
		var timer = Timer.new()
		timer.wait_time = delay
		timer.one_shot = true
		timer.connect("timeout", audio_stream_player.play)
		add_child(timer)
		timer.start()
	else:
		audio_stream_player.play()
		
	audio_stream_player.finished.connect(kill.bind(audio_stream_player))
	
	return audio_stream_player
	
func kill(_audio_stream_player):
	if _audio_stream_player and is_instance_valid(_audio_stream_player):
		_audio_stream_player.queue_free()
