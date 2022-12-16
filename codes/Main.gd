extends Node2D

onready var display = $TextDisplay
onready var displayT = $TextDisplay/Timer
onready var pontos = $Pontuacao
onready var sTabuleiro = $SpawnTabuleiro
onready var sPecas = $SpawnPecas
onready var tabuleiro = $Sombras
onready var pecas = $Pecas
onready var rng = RandomNumberGenerator.new()

const oCode = preload("res://scenes/Objeto_Base.tscn")
const rCode = preload("res://scenes/Receptor_Base.tscn")

var animais = [ ]
var spawned = [ ]
var tSpawned = [ ]
var clicked = null

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
	
# warning-ignore:unused_variable
	for i in range(sTabuleiro.get_child_count()): # Making sure that the size of the array is iqual the ammount of "spawns"
		spawned.append(null)
		tSpawned.append(null)
	
	var c = 0
	
	animais.shuffle()
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
		c+=1
		print(i)
	
	#dir.queue_free()
	var font = DynamicFont.new()
	font.font_data = load("res://fonts/8bitOperatorPlus8.ttf")
	font.size = 96
	display.add_font_override("font", font)
	display.rect_scale = Vector2(0.5, 0.5)
	display.rect_size = display.rect_size * 2

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

func set_clicked(obj):
	if not clicked == null:
		return
	clicked = obj

func get_clicked():
	return clicked

func clear_clicked():
	clicked = null
