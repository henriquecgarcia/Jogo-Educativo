extends Control

onready var title = $Nome

const cCode = preload("res://scenes/Credits.tscn")

func _ready():
	var font = DynamicFont.new()
	font.font_data = load("res://fonts/8bitOperatorPlus8.ttf")
	font.size = 96 * 1.5
	
	title.add_font_override("font", font)
	title.rect_scale = Vector2(0.5, 0.5)
	title.rect_size *= 2

func _on_Play_button_up():
	if get_tree().change_scene("res://Main.tscn"):
		get_tree().quit()

func _on_Sair_button_up():
	get_tree().quit()

func _on_Creditos_button_up():
	var cred = cCode.instance()
	add_child(cred)

onready var musicStats = not Settings.MusicStats
onready var music = $GridContainer/StopMusic

const muted_pressed = preload("res://images/musica_mutado_apertado.png")
const muted_normal = preload("res://images/musica_mutado.png")
const playing_press = preload("res://images/musica_apertado.png")
const playing_norm = preload("res://images/musica.png")

func _on_StopMusic_button_up():
	Settings.MusicStats = musicStats
	musicStats = not musicStats
	if musicStats:
		music.texture_normal = muted_normal
		music.texture_pressed = muted_pressed
	else:
		music.texture_normal = playing_norm
		music.texture_pressed = playing_press
