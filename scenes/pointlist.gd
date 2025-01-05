extends Node2D
var dragged = false
var posible_games = [] 
var one = []
var two = []
var three = []
var four = []
var five = []
var six = []

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
var go_for_double = false
var current_points = null
var current_index = -1

func _ready():
	fade_out()
	Global.point_list = self
	
func _physics_process(delta):
	if dragged:
		global_position = get_global_mouse_position()

func fade_out():
	visible = false

func fade_in():
	visible = true
	reset_points_table()
	calc_posible_points()
	
func reset_points_table():
	for i in range(12):
		$items.set_item_disabled(i, false)
	
func calc_posible_points():
	current_points = null
	current_index = -1
	go_for_double = false
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
	
	var dices = get_tree().get_nodes_in_group("dices")
	for dice in dices:
		if dice.currentvalue != null:
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
		double_game = search_double()
	else:
		$items.set_item_disabled(Global.Games.DOUBLE, true)
		
	if blocked_games.find(Global.Games.FLUSH) == -1:
		flush_game = search_flush()
	else:
		$items.set_item_disabled(Global.Games.FLUSH, true)
		
	if blocked_games.find(Global.Games.FULL) == -1:
		full_game = search_full()
	else:
		$items.set_item_disabled(Global.Games.FULL, true)
		
	if blocked_games.find(Global.Games.POKER) == -1:
		poker_game = search_poker()
	else:
		$items.set_item_disabled(Global.Games.POKER, true)
		
	if blocked_games.find(Global.Games.GENERALA) == -1:
		generala_game = search_generala()
	else:
		$items.set_item_disabled(Global.Games.GENERALA, true)
		if blocked_games.find(Global.Games.GENERALA2) == -1:
			go_for_double = true
			generala_game = search_generala()
		else:
			$items.set_item_disabled(Global.Games.GENERALA2, true)
	
	if blocked_games.find(Global.Games.ONE) == -1:
		one_game = one
	
	if blocked_games.find(Global.Games.TWO) == -1:
		two_game = two
	else:
		$items.set_item_disabled(Global.Games.TWO, true)
		
	if blocked_games.find(Global.Games.THREE) == -1:
		three_game = three
	else:
		$items.set_item_disabled(Global.Games.THREE, true)
		
	if blocked_games.find(Global.Games.FOUR) == -1:
		four_game = four
	else:
		$items.set_item_disabled(Global.Games.FOUR, true)
		
	if blocked_games.find(Global.Games.FIVE) == -1:
		five_game = five
	else:
		$items.set_item_disabled(Global.Games.FIVE, true)
		
	if blocked_games.find(Global.Games.SIX) == -1:
		six_game = six
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
		if go_for_double:
			item_selected_fake(Global.Games.GENERALA2)
		else:
			item_selected_fake(Global.Games.GENERALA)
		
func search_flush():
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

func search_double():
	var count = 0
	var result = []
	var todos = [one, two, three, four, five, six]
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

func search_full():
	var todos = [one, two, three, four, five, six]
	var result = []
	var count = 0
	var llo : Array
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
	
func search_poker():
	var todos = [one, two, three, four, five, six]
	var result = []
	var count = 0
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
	
func search_generala():
	var todos = [one, two, three, four, five, six]
	var result = []
	var count = 0
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
	var points = ""
	match index:
		Global.Games.ONE:
			points = str(one.size())
		Global.Games.TWO:
			points = str(two.size() * 2)
		Global.Games.THREE:
			points = str(three.size() * 3)
		Global.Games.FOUR:
			points = str(four.size() * 4)
		Global.Games.FIVE:
			points = str(five.size() * 5)
		Global.Games.SIX:
			points = str(six.size() * 6)
		Global.Games.DOUBLE:
			points = str(Global.points_normal[Global.Games.DOUBLE])
		Global.Games.FLUSH:
			points = str(Global.points_normal[Global.Games.FLUSH])
		Global.Games.FULL:
			points = str(Global.points_normal[Global.Games.FULL])
		Global.Games.POKER:
			points = str(Global.points_normal[Global.Games.POKER])
		Global.Games.GENERALA:
			points = str(Global.points_normal[Global.Games.GENERALA])
		Global.Games.GENERALA2:
			points = str(Global.points_normal[Global.Games.GENERALA2])
	
	if points != "":
		$items2.set_item_text(index, points)

func _on_button_pressed():
	blocked_games.append(current_index)

func _on_items_item_selected(index):
	current_points = $items2.get_item_text(index)
	current_index = index
	if current_points == "-":
		current_points = 0
	else:
		current_points = int(current_points)
		
	var dices = get_tree().get_nodes_in_group("dices")
	show_enfasis(dices, false)
		
	match index:
		Global.Games.ONE:
			show_enfasis(one_game, true)
		Global.Games.TWO:
			show_enfasis(two_game, true)
		Global.Games.THREE:
			show_enfasis(three_game, true)
		Global.Games.FOUR:
			show_enfasis(four_game, true)
		Global.Games.FIVE:
			show_enfasis(five_game, true)
		Global.Games.SIX:
			show_enfasis(six_game, true)
		Global.Games.DOUBLE:
			show_enfasis(double_game, true)
		Global.Games.FLUSH:
			show_enfasis(flush_game, true)
		Global.Games.FULL:
			show_enfasis(full_game, true)
		Global.Games.POKER:
			show_enfasis(poker_game, true)
		Global.Games.GENERALA or Global.Games.GENERALA2:
			show_enfasis(generala_game, true)

	$"../lbl_points/lbl_points2".text = str(current_points)

func show_enfasis(dices, value):
	for d in dices:
		d.show_enfasis(value)

func _on_input_event(viewport, event, shape_idx):
	if visible:
		if !dragged:
			if event is InputEventMouseButton && event.is_action_pressed("click"):
				dragged = true
		if dragged:
			if event is InputEventMouseButton && event.is_action_released("click"):
				dragged = false
