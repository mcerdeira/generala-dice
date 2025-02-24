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
var PointsShow = null
var LastTurn = false
var TurnUsed = false
var DiceMan = null
var Mark1 = null
var Mark2 = null
var Mark3 = null
var Mark4 = null
var Mark5 = null

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
}

var GamesPlayed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

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
	Teseracto,
	Shrodinger,
	Oscilante,
	Sinergia,
	Repetidor,
	CuboLudo,
	CuboLudoFake,
	TurnPlusPlus,
}


const DiceTypes = {
	Normal = {"id": DiceIDs.Normal, "price": 0, "texture": preload("res://sprites/dices/cube1.png"), "title": "Dado normal", "description": "Confiable dado de [color=red] 6[/color] lados."},
	Loaded = {"id": DiceIDs.Loaded, "price": 10, "texture": preload("res://sprites/dices/loaded.png"), "title": "Dado cargado", "description": "Siempre sale un [color=red] 6[/color]."},
	PlusDice = {"id": DiceIDs.PlusDice, "price": 6, "texture": preload("res://sprites/dices/plusdice.png"), "title": "Dado plus", "description": "[color=red]Suma[/color] su valor al puntaje."},
	MultDice = {"id": DiceIDs.MultDice, "price": 15, "texture": preload("res://sprites/dices/muldice.png"), "title": "Dado multiplicador", "description": "[color=red]Multiplica[/color] el puntaje por su valor."},
	MultDice2 = {"id": DiceIDs.MultDice2, "price": 10, "texture": preload("res://sprites/dices/muldice2.png"), "title": "Dado x2", "description": "[color=red]Multiplica[/color] el puntaje por [color=red] 2[/color]."},
	Copy = {"id": DiceIDs.Copy, "price": 10, "texture": preload("res://sprites/dices/copy.png"), "title": "El copion", "description": "[color=red]Copia[/color] el valor de otro dado al azar."},
	D2 = {"id": DiceIDs.D2, "price": 7, "texture": preload("res://sprites/dices/dx2.png"), "title": "Dado D2", "description": "Solo tiene [color=red] 2[/color] valores ([color=red]1, 2[/color])."},
	D3 = {"id": DiceIDs.D3, "price": 5, "texture": preload("res://sprites/dices/dx3.png"), "title": "Dado D3", "description": "Solo tiene [color=red] 3[/color] valores ([color=red]1, 2, 3[/color])."},
	TurnPlus = {"id": DiceIDs.TurnPlus, "price": 3, "texture": preload("res://sprites/dices/turnplus.png"), "title": "La vida", "description": "Mientras se tenga este dado suma [color=red] 1[/color] tirada a la partida para siempre."},
	Rubber = {"id": DiceIDs.Rubber, "price": 5, "texture": preload("res://sprites/dices/rubber.png"), "title": "Panqueque", "description": "Al tirarlo permite hacer [color=red] flip[/color] a su lado opuesto."},
	OneMoreChance = {"id": DiceIDs.OneMoreChance, "price": 10, "texture": preload("res://sprites/dices/onemore.png"), "title": "Doble y nada", "description": "Cuenta la jugada [color=red] x2[/color], bloquea la jugada por el nivel al usarlo y se [color=red] agota[/color]."},
	Cheese = {"id": DiceIDs.Cheese, "price": 15, "texture": preload("res://sprites/dices/cheese.png"), "title": "Quesito", "description": "Es un dado extra por fuera del [color=blue]cubilete[/color]. El dado extra se [color=red]agota[/color] siempre despues de la tirada."},
	Hologram = {"id": DiceIDs.Hologram, "price": 10, "texture": preload("res://sprites/dices/hologram.png"), "title": "Holo-Dado", "description": "El dado proyecta un holograma de si mismo con identico [color=red]valor[/color]."},
	Fake = {"id": DiceIDs.Fake, "price": 0, "texture": preload("res://sprites/dices/fake.png"), "title": "Dado de Papel", "description": "Dado trampa de [color=red] 1[/color] uso."},
	Teseracto = {"id": DiceIDs.Teseracto, "price": 15, "texture": preload("res://sprites/dices/teseracto.png"), "title": "Teseracto", "description": "Dado de la 4ta dimension. [color=red]Multiplica[/color] el puntaje por [color=red] 4[/color] y todas sus cara son un [color=red] 4[/color]."},
	Shrodinger = {"id": DiceIDs.Shrodinger, "price": 10, "texture": preload("res://sprites/dices/shrodinger.png"), "title": "El dado de Schrödinger", "description": "Todas sus caras están indefinidas hasta que se selecciona una [color=red]jugada[/color]."},
	Oscilante = {"id": DiceIDs.Oscilante, "price": 5, "texture": preload("res://sprites/dices/oscilante.png"), "title": "Dados-cilante", "description": "En las tiradas pares sale un valor par, en las impares un valor impar."},
	Sinergia = {"id": DiceIDs.Sinergia, "price": 10, "texture": preload("res://sprites/dices/sinergia.png"), "title": "Dado sinergia", "description": "Multiplica por el valor total de los dados del su mismo [color=red]valor[/color]"},
	Repetidor = {"id": DiceIDs.Repetidor, "price": 10, "texture": preload("res://sprites/dices/repetidor.png"), "title": "Dado repetidor", "description": "Si se usa este dado en una jugada ya usada anteriormente nos da [color=red]2 x numero[/color] de veces que jugamos esa jugada."},
	CuboLudo = {"id": DiceIDs.CuboLudo, "price": 10, "texture": preload("res://sprites/dices/cuboludoinicial.png"), "title": "Cubo-ludo", "description": "Es un dado extra por fuera del [color=blue]cubilete[/color]. Contiene cosas [color=blue]buenas[/color] y cosas [color=red]malas[/color], a riesgo del consumidor."},
	CuboLudoFake = {"id": DiceIDs.CuboLudoFake, "price": 10, "texture": preload("res://sprites/dices/cuboludo.png"), "title": "Dado modificador", "description": "Contiene cosas [color=blue]buenas[/color] y cosas [color=red]malas[/color]."},
	TurnPlusPlus = {"id": DiceIDs.TurnPlusPlus, "price": 5, "texture": preload("res://sprites/dices/turnplusplus.png"), "title": "La vida loca", "description": "Al usarse en una jugada, suma su [color=red] valor[/color] a la cantidad total de tiradas del nivel. Se agota."},
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
	DiceTypes.Teseracto,
	DiceTypes.Shrodinger,
	DiceTypes.Oscilante,
	DiceTypes.Sinergia,
	DiceTypes.Repetidor,
	DiceTypes.CuboLudo,
	DiceTypes.TurnPlusPlus
]

var DiceChancesTmp = []

var point_list = null
var points_normal = [null, null, null, null, null, null, 10, 20, 30, 40, 50] 
var points_serve = [null, null, null, null, null, null, 15, 25, 35, 45, 55] 
	
var Levels = [1, 1, 1, 1, 1]
var LevelPrices = [5, 5, 5, 5, 5]
	
var Level = 1
var LevelMax = 8
var Turn = 1
var InternarlTurn = 1
var TurnExtra = 0
var TurnMax = 7
var Points = 0
var VisualPoints = 0
var VisualPointsSign = ""
var Goals = [0, 45, 90, 180, 250, 500, 800, 1000, 2000]
var Goal = Goals[1]
var GameOver = false
var BeatTheGame = false
var Beaker = null

func init_vars():
	Status = Statuses.IDLE
	RerollCost = 2
	dices_used = 0
	DiceChancesTmp = []
	Level = 1
	LevelMax = 8
	Turn = 1
	InternarlTurn = 1
	TurnMax = 7
	Points = 900
	VisualPoints = 0
	VisualPointsSign = ""
	Goals = [0, 45, 90, 180, 250, 500, 800, 1000, 2000]
	Goal = Goals[1]
	GameOver = false
	BeatTheGame = false
	Beaker = null
	LastTurn = false
	TurnUsed = false
	Levels = [1, 1, 1, 1, 1]
	LevelPrices = [5, 5, 5, 5, 5]
	point_list = null
	points_normal = [null, null, null, null, null, null, 10, 20, 30, 40, 50] 
	points_serve = [null, null, null, null, null, null, 15, 25, 35, 45, 55] 
	GamesPlayed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	TurnExtra = 0

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
	
func _process(delta):
	Global.LastTurn = (Turn == TurnMax + TurnExtra)
	
func get_timer_value(score: int, max_time: float = 2.5, min_time: float = 0.05, scaling_factor: float = 5.0) -> float:
	var timer_value = scaling_factor / (score + 1)
	return clamp(timer_value, min_time, max_time)

func Next(skiped = false):
	Turn += 1
	InternarlTurn += 1
	Global.TurnUsed = false
	if Turn > (TurnMax + TurnExtra):
		if Points < Goal:
			PointsShow.hideme()
			gameover(false)
			var local_points = Goals[Level]
			Global.VisualPoints = local_points
			RentCalculate(true)
		else:
			NextLevel()
	else:
		await get_tree().create_timer(1.4).timeout
		PointsShow.hideme()
		if !skiped:
			Global.DiceMan.arrange2()
			
func NextLevel():
	refreshPool(true, true)
	Level += 1
	TurnExtra = 0
	if Level > LevelMax:
		gameover(true)
	else:
		var local_points = Goals[Level - 1]
		Global.VisualPoints = local_points
		Global.Beaker.first = true
		Global.shaker_obj.shake(10, 2.9)
		PointsShow.showme(true)
		PointsShow.set_title("NIVEL " + str(Level-1) +  " COMPLETO!!")
		Music.pause()
		Global.play_sound(Global.VictorySFX)
		await get_tree().create_timer(5.0).timeout
		RentCalculate()
		await get_tree().create_timer(3.0).timeout
		Global.Turn = 1
		Global.InternarlTurn = 1
		Global.point_list.next_level()
		Goal = Goals[Level]
		Music.resume()
		PointsShow.hideme()
		Global.DiceMan.arrange2()
		
func RentCalculate(loser = false):
	var local_points = 0
	if !loser:
		local_points = Goals[Level - 1]
	else:
		local_points = Goals[Level]
		
	Global.VisualPoints = local_points
	Global.VisualPointsSign = "-"
	points_to(0, 1.0, "VisualPoints")
	var points = Global.Points - local_points
	await points_to(points, 1.0).finished
	Global.VisualPointsSign = "-"
	Global.VisualPoints = 0
		
func points_to(points, _speed = 1.0, property = "Points"):
	var _tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUINT)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(Global, property, points, _speed)
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
		
func destroymodifiers():
	var dices_modifiers = get_tree().get_nodes_in_group("dices_modifiers")
	for d in dices_modifiers:
		d.destruir()
		
func getRandomDiceToCopy(me, DiceMan_dices):
	var dices_list = [] + DiceMan_dices
	dices_list.shuffle()
	for d in dices_list:
		if d != me and d.DiceType != Global.DiceTypes.Copy and d.DiceType != Global.DiceTypes.Shrodinger:
			return d
			
	return null
		
func gotoBase(DiceMan_dices, Mark1, Mark2, Mark3, Mark4, Mark5):
	var marks = [Mark1, Mark2, Mark3, Mark4, Mark5]
	var dices = get_tree().get_nodes_in_group("dices")
	
	dices.sort_custom(func(a, b): return a.currentvalue > b.currentvalue)
	
	for d in dices:
		if d not in DiceMan_dices:
			var m = marks.pop_front()
			await d.move_to(m.global_position).finished
			d.minigrow()
		
func gameover(win):
	Global.BeatTheGame = win
	if win:
		Global.shaker_obj.shake(7, 7)
		PointsShow.showme(true)
	Global.point_list.fade_in()
	Global.GameOver = true
	var dices = get_tree().get_nodes_in_group("dices")
	dices.sort_custom(func(a, b): return a.currentvalue > b.currentvalue)
	var marks = [Global.Mark1, Global.Mark2, Global.Mark3, Global.Mark4, Global.Mark5]
	for d in dices:
		var m = marks.pop_front()
		await d.move_to(m.global_position).finished
		d.destruir()

func minforTurn():
	if Global.Beaker.first:
		return 5
	else:
		return 1
		
func getDiceExtraText(DiceType, currentvalue, me):
	if DiceType == Global.DiceTypes.MultDice:
		return "X" + str(currentvalue)
	elif DiceType == Global.DiceTypes.PlusDice:
		return "+" + str(currentvalue)
	elif DiceType == Global.DiceTypes.MultDice2:
		return "X" + str(2)
	elif DiceType == Global.DiceTypes.Teseracto:
		return "X" + str(4)
	elif DiceType == Global.DiceTypes.Sinergia:
		var mult = Global.findDicesWithaValue(currentvalue, me)
		if mult > 1:
			return "X" + str(mult)
		else:
			return ""
	else:
		return ""
		
func findDicesWithaValue(val, me):
	var value = 0
	var dices = get_tree().get_nodes_in_group("dices")
	for d in dices:
		if (d.currentvalue == val or d.currentvalue == -1):
			value += 1
			
	return value
		
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
