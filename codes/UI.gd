extends Control

onready var botoes = $Botoes
onready var music = $Botoes/Music
onready var musicStats = not Settings.MusicStats

const muted_pressed = preload("res://images/musica_mutado_apertado.png")
const muted_normal = preload("res://images/musica_mutado.png")
const playing_press = preload("res://images/musica_apertado.png")
const playing_norm = preload("res://images/musica.png")

func scale_buttons():
	for pbutton in botoes.get_children():
		if pbutton.rect_size == Vector2(64, 64):
			continue
		pbutton.rect_scale = Vector2(64, 64) / pbutton.rect_size
		pbutton.rect_size = Vector2(64, 64)

func _ready():
	scale_buttons()

func printInoperante():
	print("Botão inoperante :P")

func _on_Jogar_button_up():
	var main = get_tree().get_current_scene()
	main.toogle_pause()

func _on_Ajuda_button_up():
	printInoperante()

func _on_Reiniciar_button_up():
	# warning-ignore:return_value_discarded
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Music_button_up():
	Settings.MusicStats = musicStats
	musicStats = not musicStats
	if musicStats:
		music.texture_normal = muted_normal
		music.texture_pressed = muted_pressed
	else:
		music.texture_normal = playing_norm
		music.texture_pressed = playing_press

const cCode = preload("res://scenes/Credits.tscn")

func _on_Credits_button_up():
	var cred = cCode.instance()
	add_child(cred)
