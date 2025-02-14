extends Node2D
var done = false
var prefix = "\n\n"

func _ready():
	$Button.text = "Re\nRoll:\n$" + str(Global.RerollCost)
	visible = false
	
func showme(val):
	visible = val
	showlevels()
	
func showlevels():
	var i = 0
	for l in Global.Levels:
		$items2.set_item_text(i, "Niv " + str(l))
		$items4.set_item_text(i, str(Global.points_normal[i + 6]))
		$items3.set_item_text(i, "$" + str(Global.LevelPrices[i]))
		i += 1

func _on_items_2_item_selected(index):
	if canBuy(Global.LevelPrices[index]):
		Global.play_sound(Global.BuySFX)
		Global.Levels[index] += 1
		Global.points_serve[index + 6] += 5
		Global.points_normal[index + 6] += 5
		Global.LevelPrices[index] += 15
		showlevels()
	else:
		Global.play_sound(Global.GlassSFX)
		$lbl_item_desc2.text = prefix +  "No tienes suficiente dinero."
		Global.shaker_obj.shake(6, 0.5)

func _process(delta):
	$lbl_points/lbl_points2.text = "$" + str(Global.Points)
	if visible and !done:
		var diceshopcurrent = get_tree().get_nodes_in_group("diceshopcurrents")
		var dices_real = get_tree().get_nodes_in_group("dices")
		for i in range(diceshopcurrent.size()):
			diceshopcurrent[i].ChangeType(dices_real[i].DiceType, dices_real[i])
			done = true

func _on_button_4_pressed(): #Cerrar
	Global.emit(get_global_mouse_position(), 1)
	Global.play_sound(Global.ButtonSFX)
	Music.pitch_to(1.0)
	visible = !visible
	done = false
	unselectall()
	
func unselectall():
	$lbl_item_desc2.text = ""
	$lbl_item_desc.text = ""
	var diceshopcurrent = get_tree().get_nodes_in_group("diceshopcurrents")
	var dices = get_tree().get_nodes_in_group("diceshop")
	for d in diceshopcurrent:
		d.unselect()
	for d in dices:
		d.unselect()
	
func canBuy(price):
	if Global.Points >= price:
		Global.Points -= price
		return true
	else:
		return false

func _on_button_5_pressed(): #Comprar
	Global.emit(get_global_mouse_position(), 1)
	var reemplazo = null
	var nuevo = null
	var diceshopcurrent = get_tree().get_nodes_in_group("diceshopcurrents")
	for d in diceshopcurrent:
		if d.selected:
			reemplazo = d
	
	var dices = get_tree().get_nodes_in_group("diceshop")
	for d in dices:
		if d.selected:
			nuevo = d
			
	if reemplazo == null:
		Global.play_sound(Global.GlassSFX)
		$lbl_item_desc2.text = prefix + "Selecciona un dado a reemplazar."
		Global.shaker_obj.shake(6, 0.5)
		return
	
	if nuevo == null:
		Global.play_sound(Global.GlassSFX)
		$lbl_item_desc2.text = prefix + "Selecciona un dado a comprar."
		Global.shaker_obj.shake(6, 0.5)
		return
		
	if canBuy(nuevo.price):
		Global.play_sound(Global.BuySFX)
		
		#Quitar el dado comprado del pool de dados
		for e in range(0, Global.DiceChances.size()):
			if Global.DiceChances[e] == nuevo.DiceType:
				Global.DiceChances.remove_at(e)
				break
				
		#Sumar el dado reemplazado al pool de nuevo, si no es el dado normal
		if reemplazo.DiceType != Global.DiceTypes.Normal:
			Global.DiceChances.append(reemplazo.DiceType)
		
		if reemplazo.DiceType == Global.DiceTypes.TurnPlus:
			Global.TurnMax -= 1
		
		reemplazo.ChangeType(nuevo.DiceType, reemplazo.real_dice)
		reemplazo.real_dice.ChangeType(nuevo.DiceType)
		nuevo.buy()
		if nuevo.DiceType == Global.DiceTypes.TurnPlus:
			Global.TurnMax += 1
			
		unselectall()
	else:
		Global.play_sound(Global.GlassSFX)
		$lbl_item_desc2.text = prefix +  "No tienes suficiente dinero."
		Global.shaker_obj.shake(6, 0.5)

func _on_button_pressed():
	Global.emit(get_global_mouse_position(), 1)
	unselectall()
	Global.play_sound(Global.ButtonSFX)
	if Global.Points >= Global.RerollCost:
		Global.play_sound(Global.BuySFX)
		Global.Points -= Global.RerollCost
		Global.RerollCost += 5
		$Button.text = "Re\nRoll:\n$" + str(Global.RerollCost)
		Global.refreshPool(true)
	else:
		Global.play_sound(Global.GlassSFX)
		$lbl_item_desc2.text = prefix +  "No tienes suficiente dinero."
		Global.shaker_obj.shake(6, 0.5)
