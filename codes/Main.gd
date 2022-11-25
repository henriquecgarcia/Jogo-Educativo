extends Node2D

onready var display = $TextDisplay
onready var displayT = $TextDisplay/Timer

const animais = [ "elefante", "dinosauro" ]

var first = true

func _ready():
	for i in animais:
		print(i)

func set_display(texto):
	display.self_modulate.a = 1
	display.text = texto
	displayT.start(5)

func _process(delta):
	if first:
		return
	display.self_modulate.a = displayT.time_left/5

func _on_Timer_timeout():
	if first:
		first = false
		displayT.start(5)
	else:
		display.text = ""
		first = true
