extends Area2D

onready var collision = $CollisionShape2D
onready var skin = $Sprite

var original_pos : Vector2

signal placed(obj, shade, isCorrect)
signal object_taken(objName)
signal object_released(objName)

var mouseIn = false
var objeto = "Não Nomeado"
var status = 0
var canBlock = false
var area = null

func Deploy(pos, objName):
	var dir = Directory.new()
	if not dir.dir_exists("animais/"+objName):
		print("Path not found for animal: \"", objName, "\".")
		return false
	var model = load("res://animais/"+objName+"/objeto.png")
	if not model:
		print("Model not found for "+objName+"...")
		return false
	objeto = objName
	skin.texture = model
	original_pos = pos
	
	var size = ( (Vector2(140, 107.5)) / model.get_size() ) # Pro elefante, isso deve ser 0.5
	#var size = 0.5
	size = min(size[1], size[0])
	
	skin.scale = Vector2(size, size)
	
	collision.position = skin.position
	
	#var spriteSize = skin.texture.get_size() * size * size * size
	#collision.shape.set_extents(spriteSize - Vector2(1, 1))
	#collision.shape.set_extents(spriteSize)
	
	position = pos
	return true

func _process(_delta):
	if canBlock and status != 0:
		return
	if Input.is_action_just_released("ui_mouse_click"):
		emit_signal("object_released", objeto)
		if area:
			canBlock = area.objeto == objeto
			#print(self, area)
			emit_signal("placed", self, area, area.objeto == objeto)
	if (mouseIn and Input.is_action_pressed("ui_mouse_click")):
		if Input.is_action_just_pressed("ui_mouse_click"):
			emit_signal("object_taken", objeto)
		position = get_viewport().get_mouse_position()

func set_status(stat):
	if not canBlock:
		return
	if stat == "Connected":
		status = 1

func get_objeto():
	return objeto

func is_mouseIn():
	return mouseIn

func _on_Objeto_mouse_entered():
	if Input.is_action_pressed("ui_mouse_click"):
		return
	mouseIn = true

func _on_Objeto_mouse_exited():
	if not Input.is_action_pressed("ui_mouse_click"):
		mouseIn = false

func _on_Objeto_area_entered(_area):
	if not _area.objeto or _area.has_method("get_objeto"):
		return
	area = _area

func _on_Objeto_area_exited(_area):
	if not _area.objeto or _area.has_method("get_objeto"):
		return
	area = null
