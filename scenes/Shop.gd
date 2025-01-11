extends Node2D
var done = false
var prefix = "\n\n"

func _ready():
	visible = false

func _process(delta):
	if visible and !done:
		$lbl_points/lbl_points2.text = "$" + str(Global.Points)
		var diceshopcurrent = get_tree().get_nodes_in_group("diceshopcurrents")
		var dices_real = get_tree().get_nodes_in_group("dices")
		for i in range(diceshopcurrent.size()):
			diceshopcurrent[i].ChangeType(dices_real[i].DiceType, dices_real[i])
			done = true

func _on_button_4_pressed(): #Cerrar
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
		$lbl_item_desc2.text = prefix + "Selecciona un dado a reemplazar."
		Global.shaker_obj.shake(6, 0.5)
		return
	
	if nuevo == null:
		$lbl_item_desc2.text = prefix + "Selecciona un dado a comprar."
		Global.shaker_obj.shake(6, 0.5)
		return
		
	if canBuy(nuevo.price):
		if reemplazo.DiceType == Global.DiceTypes.TurnPlus:
			Global.TurnMax -= 1
		
		reemplazo.ChangeType(nuevo.DiceType, reemplazo.real_dice)
		reemplazo.real_dice.ChangeType(nuevo.DiceType)
		nuevo.buy()
		if nuevo.DiceType == Global.DiceTypes.TurnPlus:
			Global.TurnMax += 1
			
		unselectall()
	else:
		$lbl_item_desc2.text = prefix +  "No tienes suficiente dinero."
		Global.shaker_obj.shake(6, 0.5)
