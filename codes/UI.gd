extends Control

onready var botoes = $Botoes

func scale_buttons():
	for pbutton in botoes.get_children():
		if pbutton.rect_size == Vector2(64, 64):
			continue
		pbutton.rect_scale = Vector2(64, 64) / pbutton.rect_size
		pbutton.rect_size = Vector2(64, 64)

func printInoperante():
	print("Botão inoperante :P")

func _on_Jogar_button_up():
	var main = get_tree().get_current_scene()
	print(main)
	main.toogle_pause()

func _on_Ajuda_button_up():
	printInoperante()

func _on_Reiniciar_button_up():
	# warning-ignore:return_value_discarded
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Music_button_up():
	printInoperante()

func _on_Credits_button_up():
	printInoperante()
