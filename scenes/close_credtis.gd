extends TextureButton

func _on_TextureButton_button_up():
	get_parent().queue_free()
