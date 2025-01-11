extends Node3D
var price = 0
var description = ""
var title = ""

func _ready():
	price = $dice3D.price
	description = $dice3D.description
	title = $dice3D.title
