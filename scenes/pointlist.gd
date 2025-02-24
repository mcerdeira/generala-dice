extends Node2D
var dragged = false
var posible_games = [] 
var one = []
var two = []
var three = []
var four = []
var five = []
var six = []
var undefined = []

var double_game = []
var flush_game = []
var full_game = []
var poker_game = []
var generala_game = []

var one_game = []
var two_game = []
var three_game = []
var four_game = []
var five_game = []
var six_game = []
var blocked_games = []
var current_points = null
var current_index = -1
var current_dices = null
var TimerSpeed = 0
var OriginalPitchScale = 2.0
var PitchScale = OriginalPitchScale

func _on_btn_sound_pressed():
	var val = $btn_sound/txtval.text
	testSound(val)

func testSound(val):
	var local_points = int(val)
	PitchScale = OriginalPitchScale
	TimerSpeed = Global.get_timer_value(local_points)
	$Timer.wait_time = TimerSpeed
	$Timer.start()
	Global.points_to(0, 1.0, "VisualPoints")
	await Global.points_to(local_points).finished
	$Timer.stop()

func _ready():
	fade_out()
	Global.point_list = self
	
func _physics_process(delta):
	$Button.disabled = Global.GameOver
	if dragged:
		Global.preventSelect = true
		global_position = get_global_mouse_position()

func fade_out():
	visible = false

func recalc_forced():
	reset_points_table()
	calc_posible_points()

func fade_in():
	visible = true
	recalc_forced()
	
func refresh():
	reset_points_table()
	calc_posible_points()
	
func next_level():
	blocked_games = []
	reset_points_table()
	
func reset_points_table():
	for i in range(12):
		$items.set_item_disabled(i, false)
		if blocked_games.find(i) == -1:
			$items2.set_item_text(i, "-")
	
func calc_posible_points():
	current_points = null
	current_dices = null
	current_index = -1
	double_game = []
	flush_game = []
	full_game = []
	poker_game = []
	generala_game = []
	
	one_game = []
	two_game = []
	three_game = []
	four_game = []
	five_game = []
	six_game = []
	
	one = []
	two = []
	three = []
	four = []
	five = []
	six = []
	undefined = []

	var extra_dices = get_tree().get_nodes_in_group("dices_extra")
	var dices = get_tree().get_nodes_in_group("dices")
	
	dices.append_array(extra_dices)
	
	for dice in dices:
		if dice.currentvalue != null:
			if dice.currentvalue == -1:
				undefined.append(dice)
			if dice.currentvalue == 1:
				one.append(dice)
			if dice.currentvalue == 2:
				two.append(dice)
			if dice.currentvalue == 3:
				three.append(dice)
			if dice.currentvalue == 4:
				four.append(dice)
			if dice.currentvalue == 5:
				five.append(dice)
			if dice.currentvalue == 6:
				six.append(dice)
	
	if blocked_games.find(Global.Games.DOUBLE) == -1:
		double_game = search_double(undefined)
	else:
		$items.set_item_disabled(Global.Games.DOUBLE, true)
		
	if blocked_games.find(Global.Games.FLUSH) == -1:
		flush_game = search_flush(undefined)
	else:
		$items.set_item_disabled(Global.Games.FLUSH, true)
		
	if blocked_games.find(Global.Games.FULL) == -1:
		full_game = search_full(undefined)
	else:
		$items.set_item_disabled(Global.Games.FULL, true)
		
	if blocked_games.find(Global.Games.POKER) == -1:
		poker_game = search_poker(undefined)
	else:
		$items.set_item_disabled(Global.Games.POKER, true)
		
	if blocked_games.find(Global.Games.GENERALA) == -1:
		generala_game = search_generala(undefined)
	else:
		$items.set_item_disabled(Global.Games.GENERALA, true)
	
	if blocked_games.find(Global.Games.ONE) == -1:
		one_game = one + undefined
	
	if blocked_games.find(Global.Games.TWO) == -1:
		two_game = two + undefined
	else:
		$items.set_item_disabled(Global.Games.TWO, true)
		
	if blocked_games.find(Global.Games.THREE) == -1:
		three_game = three + undefined
	else:
		$items.set_item_disabled(Global.Games.THREE, true)
		
	if blocked_games.find(Global.Games.FOUR) == -1:
		four_game = four + undefined
	else:
		$items.set_item_disabled(Global.Games.FOUR, true)
		
	if blocked_games.find(Global.Games.FIVE) == -1:
		five_game = five + undefined
	else:
		$items.set_item_disabled(Global.Games.FIVE, true)
		
	if blocked_games.find(Global.Games.SIX) == -1:
		six_game = six + undefined
	else:
		$items.set_item_disabled(Global.Games.SIX, true)
	
	if one_game.size() > 0:
		item_selected_fake(Global.Games.ONE)
	if two_game.size() > 0:
		item_selected_fake(Global.Games.TWO)
	if three_game.size() > 0:
		item_selected_fake(Global.Games.THREE)
	if four_game.size() > 0:
		item_selected_fake(Global.Games.FOUR)
	if five_game.size() > 0:
		item_selected_fake(Global.Games.FIVE)
	if six_game.size() > 0:
		item_selected_fake(Global.Games.SIX)
		
	if double_game.size() > 0:
		item_selected_fake(Global.Games.DOUBLE)
	if flush_game.size() > 0:
		item_selected_fake(Global.Games.FLUSH)
	if full_game.size() > 0:
		item_selected_fake(Global.Games.FULL)
	if poker_game.size() > 0:
		item_selected_fake(Global.Games.POKER)
	if generala_game.size() > 0:
		item_selected_fake(Global.Games.GENERALA)
			
func search_flush(undefined = null):
	var result = []
	if one.size() > 0 and two.size() > 0 and three.size() > 0 and four.size() > 0 and five.size() > 0:
		result.append_array(one)
		result.append_array(two)
		result.append_array(three)
		result.append_array(four)
		result.append_array(five)
	if two.size() > 0 and three.size() > 0 and four.size() > 0 and five.size() > 0 and six.size() > 0:
		result.append_array(two)
		result.append_array(three)
		result.append_array(four)
		result.append_array(five)
		result.append_array(six)
	if three.size() > 0 and four.size() > 0 and five.size() > 0 and six.size() > 0 and one.size() > 0:
		result.append_array(three)
		result.append_array(four)
		result.append_array(five)
		result.append_array(six)
		result.append_array(one)
		
	return result

func search_double(undefined = null):
	var break_all = false
	var count = 0
	var result = []
	var todos = [one, two, three, four, five, six]
	if undefined:
		for i in range(5, 0, -1):
			todos = [one, two, three, four, five, six]
			todos[i] += undefined
			for t in todos:
				if t.size()>= 2:
					result.append_array(t)
					count += 1
					if count >= 2:
						break_all = true
						break
			
			if break_all:
				undefined[0].set_shrodinger_dimensions(Global.Games.DOUBLE, i + 1)
				break
						
		if count >= 2:
			return result
		else:
			return []
	else:
		for t in todos:
			if t.size() >= 2:
				result.append_array(t)
				count += 1
				if count >= 2:
					break
	
		if count >= 2:
			return result
		else:
			return []

func search_full(undefined = null):
	var todos = [one, two, three, four, five, six]
	var result = []
	var count = 0
	if undefined:
		for i in range(5, 0, -1):
			todos = [one, two, three, four, five, six]
			todos[i] += undefined
			#Buscar 3 iguales
			for t in todos:
				if t.size() >= 3:
					result.append_array(t)
					todos.erase(t)
					count += 1
					break
			
			#Buscar 2 iguales en los restantes
			for t in todos:
				if t.size() >= 2:
					result.append_array(t)
					count += 1
					break
			
			if count >= 2:
				undefined[0].set_shrodinger_dimensions(Global.Games.FULL, i + 1)
				return result
		
		return []
	else:
		#Buscar 3 iguales
		for t in todos:
			if t.size() >= 3:
				result.append_array(t)
				todos.erase(t)
				count += 1
				break
		
		#Buscar 2 iguales en los restantes
		for t in todos:
			if t.size() >= 2:
				result.append_array(t)
				count += 1
				break
		
		if count >= 2:
			return result
		else:
			return []
	
func search_poker(undefined = null):
	var todos = [one, two, three, four, five, six]
	var result = []
	var count = 0
	if undefined:
		for i in range(5, 0, -1):
			todos = [one, two, three, four, five, six]
			todos[i] += undefined
			#Buscar 4 iguales, se asume que entonces hay 1 mas
			for t in todos:
				if t.size() >= 4:
					result.append_array(t)
					todos.erase(t)
					count += 1
					break
					
			#Buscar 1 iguales en los restantes
			for t in todos:
				if t.size() >= 1:
					result.append_array(t)
					count += 1
					break
			
			if count >= 2:
				undefined[0].set_shrodinger_dimensions(Global.Games.POKER, i + 1)
				return result
				
		return []
	else:
		#Buscar 4 iguales, se asume que entonces hay 1 mas
		for t in todos:
			if t.size() >= 4:
				result.append_array(t)
				todos.erase(t)
				count += 1
				break
				
		#Buscar 1 iguales en los restantes
		for t in todos:
			if t.size() >= 1:
				result.append_array(t)
				count += 1
				break
		
		if count >= 2:
			return result
		else:
			return []
	
func search_generala(undefined = null):
	var todos = [one, two, three, four, five, six]
	var result = []
	var count = 0
	if undefined:
		for i in range(5, 0, -1):
			todos = [one, two, three, four, five, six]
			todos[i] += undefined
			#Buscar 5 iguales, se asume que entonces hay 1 mas
			for t in todos:
				if t.size() >= 5:
					result.append_array(t)
					count += 1
					break
			if count >= 1:
				undefined[0].set_shrodinger_dimensions(Global.Games.GENERALA, i + 1)
				return result
		
		return []
	else:
		#Buscar 5 iguales, se asume que entonces hay 1 mas
		for t in todos:
			if t.size() >= 5:
				result.append_array(t)
				count += 1
				break
		if count >= 1:
			return result
		else:
			return []

func item_selected_fake(index):
	var points_calc = Global.points_normal
	if Global.dices_used >= 5:
		points_calc = Global.points_serve
		
	var points = ""
	match index:
		Global.Games.ONE:
			points = str(one_game.size())
		Global.Games.TWO:
			points = str(two_game.size() * 2)
		Global.Games.THREE:
			points = str(three_game.size() * 3)
		Global.Games.FOUR:
			points = str(four_game.size() * 4)
		Global.Games.FIVE:
			points = str(five_game.size() * 5)
		Global.Games.SIX:
			points = str(six_game.size() * 6)
		Global.Games.DOUBLE:
			points = str(points_calc[Global.Games.DOUBLE])
		Global.Games.FLUSH:
			points = str(points_calc[Global.Games.FLUSH])
		Global.Games.FULL:
			points = str(points_calc[Global.Games.FULL])
		Global.Games.POKER:
			points = str(points_calc[Global.Games.POKER])
		Global.Games.GENERALA:
			points = str(points_calc[Global.Games.GENERALA])
	
	if points != "":
		$items2.set_item_text(index, points)
		
func clearSelected():
	for i in range($items.item_count):
		$items.deselect(i)

func _on_button_pressed(): #ANOTAR
	if $items2.get_item_text(current_index) and $items2.get_item_text(current_index) != "-":
		fade_out()
		Global.shaker_obj.shake(8, 2.3)
		Global.emit(get_global_mouse_position(), 1)
		Music.pause()
		Global.play_sound(Global.ButtonSFX)
		Global.play_sound(Global.VictorySFX)
		Global.GamesPlayed[current_index] += 1
		var add = 0
		var mult = 0
		var block = false
		var repetir_extra = false
		var blocker_dice = null
		var turn_dice = null
		if current_dices and current_dices.size() > 0:
			#Calculos de puntos
			for d in current_dices:
				if d.DiceType == Global.DiceTypes.Repetidor:
					repetir_extra = true
					
				if d.DiceType == Global.DiceTypes.TurnPlusPlus:
					Global.TurnExtra = d.currentvalue
					turn_dice = d  
				
				if d.DiceType == Global.DiceTypes.OneMoreChance:
					block = true
					blocker_dice = d
				
				if d.DiceType == Global.DiceTypes.PlusDice:
					add += d.currentvalue
					
			if repetir_extra:
				if Global.GamesPlayed[current_index] > 1:
					add += 2 * Global.GamesPlayed[current_index]
			
			for d in current_dices:
				if d.DiceType == Global.DiceTypes.MultDice:
					mult += d.currentvalue
				if d.DiceType == Global.DiceTypes.MultDice2:
					mult += 2
				if d.DiceType == Global.DiceTypes.Teseracto:
					mult += 4
				if d.DiceType == Global.DiceTypes.Sinergia:
					var multer = Global.findDicesWithaValue(d.currentvalue, d)
					if multer > 1:
						mult += multer
					
			var dices_modifiers = get_tree().get_nodes_in_group("dices_modifiers")
			for d in dices_modifiers:
				if d.currentvalue == 1:
					mult += 2
				if d.currentvalue == 2:
					add += 5
				if d.currentvalue == 3:
					pass
				if d.currentvalue == 4:
					add -= 5
				if d.currentvalue == 5:
					skip()
					return
				if d.currentvalue == 6:
					mult += 3
					
			if add != 0:
				current_points += add
					
			if mult > 0:
				current_points *= mult 
				
			if block: #Si usamos el dado de bloqueo de jugada, es X2   
				current_points *= 2
			
			Global.play_sound(Global.ScoreSFX)
			Global.PointsShow.showme()
			
			#Traer los dados participes de la jugada
			var dices = get_tree().get_nodes_in_group("dices")
			dices.sort_custom(func(a, b): return a.currentvalue > b.currentvalue)
			
			var marks = [$"../DiceSlot1", $"../DiceSlot2", $"../DiceSlot3", $"../DiceSlot4", $"../DiceSlot5"]
			for d in dices:
				if d.enfasis_visible():
					var m = marks.pop_front()
					d.move_to(m.global_position)
				else:
					d.visible = false
			
			#Armar jugada visualmente
			var jugadita = trad_name(current_points, $items.get_item_text(current_index)) + "!"
			Global.PointsShow.set_title(jugadita)
			
			#Armar jugada visualmente II
			var local_points = Global.Points + current_points 
			Global.VisualPoints = current_points
			Global.VisualPointsSign = "+"
			
			var base_points = $items2.get_item_text(current_index)
			var add_txt = ""
			var mult_txt = ""
			if add != 0:
				add_txt = " + [color=yellow]" + str(add) + "[/color]"
			if mult > 0:
				mult_txt = " x [color=red]" + str(mult) + "[/color]"
				
			var rest = " = [color=blue]" + str(current_points) + "[/color]"
			 
			$"../PointsShow/lbl_points_calc".text = "[center]\n" + str(base_points) + add_txt + mult_txt + rest + "[/center]"
			
			for d in dices:
				d.minigrow()
			
			#Reseteo de variables
			Global.InternarlTurn = 1
			Global.Beaker.first = true
			var points_for_timer = current_points
			current_points = null
			current_dices = null
			
			#Bloquear jugada que ya se hizo
			if block:
				blocked_games.append(current_index)
				blocker_dice.agotar()
				
			if turn_dice:
				turn_dice.agotar()
			
			PitchScale = OriginalPitchScale
			#Ocultar dialogo de puntos en 3 segundos y sumar puntos con tween
			await get_tree().create_timer(3.0).timeout
			TimerSpeed = Global.get_timer_value(points_for_timer)
			$Timer.wait_time = TimerSpeed
			$Timer.start()
			Global.points_to(0, 1.0, "VisualPoints")
			await Global.points_to(local_points).finished
			$Timer.stop()
			Global.VisualPointsSign = ""
			Global.VisualPoints = 0
			
			#Reseteo de dados y estados restantes
			Global.destroymodifiers()
				
			for d in dices:
				d.show_enfasis(false)
				d.visible = true
				if d.DiceType == Global.DiceTypes.Fake:
					d.destruir()
			
			Music.resume()
			Global.Next()
	else:
		Global.play_sound(Global.GlassSFX)
		Global.shaker_obj.shake(6, 0.5)
		
func _on_timer_timeout():
	PitchScale += 0.1
	Global.play_sound(Global.ShepardSFX, {"pitch_scale": PitchScale})
	Global.shaker_obj.shake(PitchScale, 0.1)

func trad_name(points, val):
	if val == "6" or val == "5" or val == "4" or val == "3" or val == "2" or val == "1":
		return str(points) + " al " + trad_number(val)
	else:
		return val
		
func trad_number(val):
	if val == "6":
		return "SEIS"
	elif val == "5":
		return "CINCO"
	elif val == "4":
		return "CUATRO"
	elif val == "3":
		return "TRES"
	elif val == "2":
		return "DOS"
	elif val == "1":
		return "UNO"
	else:
		return ""
	
func _on_items_item_selected(index):
	if index == current_index:
		current_index = -1
		$items.deselect(index)
		var dices = get_tree().get_nodes_in_group("dices")
		show_enfasis(dices, false)
		current_points = 0
		current_dices = null
		return
	
	current_points = $items2.get_item_text(index)
	current_index = index
	if current_points == "-":
		current_points = 0
	else:
		current_points = int(current_points)
		Global.play_sound(Global.ClickSFX)
		
	var dices = get_tree().get_nodes_in_group("dices")
	show_enfasis(dices, false)
		
	match index:
		Global.Games.ONE:
			current_dices = [] + one_game
			show_enfasis(one_game, true, 1)
		Global.Games.TWO:
			current_dices = [] + two_game
			show_enfasis(two_game, true, 2)
		Global.Games.THREE:
			current_dices = [] + three_game
			show_enfasis(three_game, true, 3)
		Global.Games.FOUR:
			current_dices = [] + four_game
			show_enfasis(four_game, true, 4)
		Global.Games.FIVE:
			current_dices = [] + five_game
			show_enfasis(five_game, true, 5)
		Global.Games.SIX:
			current_dices = [] + six_game
			show_enfasis(six_game, true, 6)
		Global.Games.DOUBLE:
			current_dices = [] + double_game
			show_enfasis(double_game, true, index)
		Global.Games.FLUSH:
			current_dices = [] + flush_game
			show_enfasis(flush_game, true, index)
		Global.Games.FULL:
			current_dices = [] + full_game
			show_enfasis(full_game, true, index)
		Global.Games.POKER:
			current_dices = [] + poker_game
			show_enfasis(poker_game, true, index)
		Global.Games.GENERALA:
			current_dices = [] + generala_game
			show_enfasis(generala_game, true, index)

	$"../lbl_points/lbl_points2".text = str(current_points)

func show_enfasis(dices, value, gameidx = -1):
	for d in dices:
		d.show_enfasis(value, gameidx)

func _on_input_event(viewport, event, shape_idx):
	if visible:
		if !dragged:
			if event is InputEventMouseButton && event.is_action_pressed("click"):
				dragged = true
				Global.preventSelect = true
		if dragged:
			if event is InputEventMouseButton && event.is_action_released("click"):
				dragged = false
				Global.preventSelect = false

func _on_mouse_exited():
	if !dragged:
		Global.preventSelect = false

func _on_button_2_pressed():
	skip()

func skip():
	Global.emit(get_global_mouse_position(), 1)
	Global.shaker_obj.shake(0.5, 1.5)
	Global.play_sound(Global.ButtonSFX)
	
	#Reseteo de dados y estados restantes
	var dices = get_tree().get_nodes_in_group("dices")
	for d in dices:
		if d.DiceType == Global.DiceTypes.Fake:
			d.destruir()
			
	Global.destroymodifiers()
		
	fade_out()
	Global.Next(true)
