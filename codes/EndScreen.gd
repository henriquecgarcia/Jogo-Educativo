extends Control

func _on_TextureButton_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()
