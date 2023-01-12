extends Node

export var MusicStats : bool = true setget set_music_stats
export var SoundStats : bool = true setget set_sound_stats

signal music_stats_changed(new_stat)
signal sound_stats_changed(new_stat)

func set_music_stats(new_val := true):
	MusicStats = new_val
	emit_signal("music_stats_changed", new_val)

func set_sound_stats(new_val := true):
	SoundStats = new_val
	emit_signal("sound_stats_changed", new_val)

func _ready():
	Credits.add_credits("Criado por Henrique Campanha Garcia")
	Credits.add_credits("com colaboração de Pablo")
	Credits.add_credits("Orientado pela Professora Vanessa Pereira.")
	pass
