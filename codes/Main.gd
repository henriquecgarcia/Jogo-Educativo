extends Node2D

const DEBUG = true

onready var display = $TextDisplay
onready var displayT = $TextDisplay/Timer
onready var _pontos = $Pontuacao
onready var sTabuleiro = $SpawnTabuleiro
onready var sPecas = $SpawnPecas
onready var tabuleiro = $Sombras
onready var pecas = $Pecas
onready var rng = RandomNumberGenerator.new()
onready var _fulltime_player = $Constant_Player as AudioStreamPlayer2D
onready var correct_player = $Correct_Player as AudioStreamPlayer2D
onready var wrong_player = $Wrong_Player as AudioStreamPlayer2D
onready var ui = $UI as Control
onready var pbutton = $Pause/Button
onready var btn_pause = $Pause

var end = null

const oCode = preload("res://scenes/Objeto_Base.tscn")
const rCode = preload("res://scenes/Receptor_Base.tscn")
const eScreen = preload("res://scenes/EndScreen.tscn")

var animais = [ ]
var spawned = [ ]
var tSpawned = [ ]
var clicked = null
var held = [ ]
var pontos : int = 0
var correct_placed : int = 0

var first = true

func get_next_empty(arr : = [0]) -> int:
	for i in range(len(arr)):
		if not i in arr:
			return i
	return -1

func __exists_in_held(opt := "obj", key : int = 0) -> bool:
	for i in held:
		if i == null:
			continue
		if i[opt] == key:
			return true
	return false

func randPos(arr := [], opt := "obj", mult = 1) -> int:
	var cc = len(arr)
	var r : int = (rng.randi_range(0, cc * mult) + mult + cc) % cc
	if __exists_in_held(opt, r):
		return randPos(arr, opt, mult + 1)
	arr[r] = get_next_empty(arr)
	return r

func _ready():
	randomize()
	ui.visible = false
	btn_pause.visible = true
	pbutton.rect_scale = Vector2(64, 64) / pbutton.rect_size
	
	var dir = Directory.new()
	dir.open("res://animais/")
	dir.list_dir_begin()
	var file_name
	while true:
		file_name = dir.get_next()
		if file_name == "":
			break
		elif dir.current_is_dir():
			if file_name == "__Original" or file_name.begins_with(".") or file_name.begins_with(" "):
				continue
			animais.append(file_name)
	
	wrong_player.stream.loop = false
	correct_player.stream.loop = false
	_fulltime_player.stream.loop = true
	_fulltime_player.play()
	
	var sTab = []
	var sPeca = []
	
	for i in range(sTabuleiro.get_child_count()): # Making sure that the size of the array is iqual the ammount of "spawns"
		sTab.append(i)
		sPeca.append(i)
		held.append(null)
		#spawned.append(null)
		#tSpawned.append(null)
	
	sTab.shuffle()
	sPeca.shuffle()
	animais.shuffle()
	
	var c = 0
	
	while c < sTabuleiro.get_child_count():
		var r = randPos(sPeca, "obj")
		var pPos = sPecas.get_child(r).position
		var obj = oCode.instance()
		pecas.add_child(obj)
		
		#var t = randomPosTabuleiro()
		var t = randPos(sTab, "sombra")
		var sPos = sTabuleiro.get_child(t).position
		var sombra = rCode.instance()
		tabuleiro.add_child(sombra)
		
		
		var i = animais[c]
		if not obj.Deploy(pPos, i):
			obj.free()
			continue
		if not sombra.Deploy(sPos, i):
			sombra.free()
			continue
		#tSpawned[t] = sombra
		#spawned[r] = obj
		sPeca[r] = -1
		sTab[t] = -1
		obj.connect("placed", self, "set_object_placed")
		obj.connect("object_taken", self, "set_object_taken")
		obj.connect("object_released", self, "set_object_released")
		held[r] = { objeto = i, obj = r, sombra = t, total_held = 0, _start = -1 }
		c+=1
	
	ui.scale_buttons()
	
	var font = DynamicFont.new()
	font.font_data = load("res://fonts/8bitOperatorPlus8.ttf")
	font.size = 96
	display.add_font_override("font", font)
	display.rect_scale = Vector2(0.5, 0.5)
	display.rect_size = display.rect_size * 2
	
	
	var f2 = DynamicFont.new()
	f2.font_data = load("res://fonts/8bitOperatorPlus8.ttf")
	f2.size = 96 * 2/3
	_pontos.add_font_override("font", f2)
	_pontos.rect_scale = Vector2(0.5, 0.5)
	_pontos.rect_size *= 2
	
	_pontos.text = str(pontos)+" pontos"

func object_position(obj = "Nenhum") -> int:
	for i in range(len(held)):
		if held[i].objeto == obj:
			return i
	return -1

func set_display(texto):
	display.self_modulate.a = 1
	display.text = texto
	displayT.start(5)
	

# warning-ignore:unused_argument
func _process(delta):
	if correct_placed == len(held):
		_fulltime_player.volume_db -= .01
	
	if first:
		return
	display.self_modulate.a = displayT.time_left/5
	
	if not end:
		return
	
	_pontos.self_modulate.a = displayT.time_left/5
	
	var text = end.get_node("EndGameText")
	var bg = end.get_node("FadedBackground")
	var btn = end.get_node("Restart")
	
	text.self_modulate.a = 1 - (end.get_node("FadeInTimer").time_left)/5
	bg.self_modulate.a = 1 - (end.get_node("FadeInTimer").time_left)/5
	btn.self_modulate.a = 1 - (end.get_node("FadeInTimer").time_left)/5
	if bg.self_modulate.a == 1:
		_fulltime_player.stop()
	

func _on_Timer_timeout():
	if first:
		first = false
		displayT.start(5)
		if end and correct_placed == len(held):
			var ti = end.get_node("FadedBackground")
			var t = end.get_node("FadeInTimer")
			if ti.self_modulate.a == 0 and t.time_left == 0:
				t.start(5)
	else:
		display.text = ""
		first = true

func set_object_taken(objeto):
	var id = object_position(objeto)
	if id < 0:
		return
	var info = held[id]
	if info._start != -1:
		return
	info._start = Time.get_ticks_msec()

func set_object_released(objeto):
	var id = object_position(objeto)
	if id < 0:
		return
	var info = held[id]
	if info._start == -1:
		return
	info.total_held += (Time.get_ticks_msec() - info._start)
	info._start = -1

var last_shadow_placed = null

func set_object_placed(objeto, shadow, correct):
	if correct_player.playing:
		correct_player.stop()
	if wrong_player.playing:
		wrong_player.stop()
	last_shadow_placed = shadow
	if correct:
		set_display(objeto.objeto)
		var id = object_position(objeto.objeto)
		if id < 0:
			return
		var info = held[id]
		var p = info.total_held
		
		if p <= 15*1000:
			p = 100
		elif p <= 30*1000:
			p = 75
		else:
			p = int(p/1000)
			p = 100-p
			if p < 10:
				p = 10
		
		objeto.set_status("Connected")
		objeto.position = shadow.position
		correct_player.play(0.0)
		
		pontos += p
		_pontos.text = str(pontos)+" pontos"
		correct_placed += 1
		
		if shadow.has_method("change_background"):
			shadow.change_background("correct")
		
		if correct_placed == len(held):
			end = eScreen.instance()
			add_child_below_node($Listener, end)
			
			var font = DynamicFont.new()
			font.font_data = load("res://fonts/8bitOperatorPlus8.ttf")
			font.size = 96 * 2
			
			var end_text = end.get_node("EndGameText")
			var bg = end.get_node("FadedBackground")
			var btn = end.get_node("Restart")
			
			end_text.self_modulate.a = 0
			bg.self_modulate.a = 0
			btn.self_modulate.a = 0
			
			end_text.add_font_override("font", font)
			end_text.rect_scale = Vector2(0.5, 0.5)
			end_text.rect_size *= 2
			
			end_text.text += "\n"+str(pontos)+" Pontos feitos."
	else:
		objeto.position = objeto.original_pos
		wrong_player.play(0.66)
		if shadow.has_method("change_background"):
			shadow.change_background("wrong")

# Tendo a certeza q vai parar de tocar (eu acho) e pra fazer a volta das models

func _on_Correct_Player_finished():
	correct_player.stop()

func _on_Wrong_Player_finished():
	wrong_player.stop()

func _input(event):
	if not DEBUG:
		return
	if event.is_action_released("ui_accept"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func toogle_pause():
	ui.visible = not ui.visible
	btn_pause.visible = not btn_pause.visible
	get_tree().paused = not get_tree().paused

func _on_Button_button_up():
	toogle_pause()
