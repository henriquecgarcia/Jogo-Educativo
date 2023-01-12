extends Node

signal credits_added(dict)

var credits = []

func add_credits(text := "Not Given"):
	credits.append(text)
	emit_signal("credits_added", text)
