extends Node2D

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

const oCode = preload("res://scenes/Objeto_Base.tscn")
const rCode = preload("res://scenes/Receptor_Base.tscn")

var animais = [ ]
var spawned = [ ]
var tSpawned = [ ]
var clicked = null
var held = [ ]
var pontos : int = 0

var first = true

func randomPosSpawn( mult = 1 ):
	var cc = sPecas.get_child_count()
	var r = (rng.randi_range(0, cc * mult) + mult + cc )% cc
	if not spawned[r]:
		return r
	var z = spawned[r]
	var pPos = sPecas.get_child(r).position
	if is_instance_valid(z) and z.position == pPos:
		return randomPosSpawn( mult+1 )
	spawned[r] = null
	return r

func randomPosTabuleiro( mult = 1 ):
	var cc = sTabuleiro.get_child_count()
	var r = (rng.randi_range(0, cc * mult) + mult + cc )% cc
	if not tSpawned[r]:
		return r
	var z = tSpawned[r]
	var pPos = sTabuleiro.get_child(r).position
	if is_instance_valid(z) and z.position == pPos:
		return randomPosTabuleiro( mult+1 )
	tSpawned[r] = null
	return r

func _ready():
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
	
	for _i in range(sTabuleiro.get_child_count()): # Making sure that the size of the array is iqual the ammount of "spawns"
		spawned.append(null)
		tSpawned.append(null)
	
	var c = 0
	
	animais.shuffle()
	animais.shuffle()
	
	while c < sTabuleiro.get_child_count():
		var r = randomPosSpawn()
		var pPos = sPecas.get_child(r).position
		var obj = oCode.instance()
		pecas.add_child(obj)
		
		var t = randomPosTabuleiro()
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
		tSpawned[t] = sombra
		spawned[r] = obj
		obj.connect("placed", self, "set_object_placed")
		obj.connect("object_taken", self, "set_object_taken")
		obj.connect("object_released", self, "set_object_released")
		held.append({ objeto = i, obj = r, sombra = t, total_held = 0, _start = -1 })
		c+=1
	
	#dir.queue_free()
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

func set_object_placed(objeto, shadow, correct):
	if correct_player.playing:
		correct_player.stop()
	if wrong_player.playing:
		wrong_player.stop()
	if correct:
		set_display(objeto.objeto)
		var id = object_position(objeto.objeto)
		if id < 0:
			return
		var info = held[id]
		var p = info.total_held
		
		if p <= 30*1000:
			p = 100
		elif p <= 60*1000:
			p = 75
		else:
			p = int(p/1000)
			p = 100-p
			if p < 10:
				p = 10
		
		print(p, info.total_held)
		
		objeto.set_status("Connected")
		objeto.position = shadow.position
		correct_player.play(0.0)
		
		pontos += p
		_pontos.text = str(pontos)+" pontos"
	else:
		objeto.position = objeto.original_pos
		wrong_player.play(0.66)

# Tendo a certeza q vai parar de tocar (eu acho)

func _on_Correct_Player_finished():
	correct_player.stop()

func _on_Wrong_Player_finished():
	wrong_player.stop()
