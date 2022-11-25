extends Area2D

onready var skin = $Sprite
onready var collision = $CollisionShape2D

var mouseIn = false
var objeto = "Não Nomeado"
var status = 0
var canBlock = false

func Deploy(pos, objName, size = 0.5):
	var dir = Directory.new()
	if not dir.dir_exists("animais/"+objName):
		print("Path not found for animal: \"", objName, "\".")
		return
	var model = load("animals/"+objName+"/objeto.png")
	objeto = objName
	skin.set_texture(model)
	skin.scale = Vector2(size, size)
	
	var square = skin.get_rect()
	collision.position = skin.position
	
	var spriteSize = skin.texture.get_size() * skin.scale * skin.scale
	collision.shape.set_extents(spriteSize - Vector2(1, 1))

func _process(delta):
	if status != 0:
		if canBlock:
			return
		if Input.is_action_just_released("ui_mouse_click"):
			canBlock = true
	if (mouseIn and Input.is_action_pressed("ui_mouse_click")):
		position = get_viewport().get_mouse_position()

func set_status(stat):
	if stat == "Connected":
		status = 1

func get_objeto():
	return objeto


func _on_Objeto_mouse_entered():
	mouseIn = true

func _on_Objeto_mouse_exited():
	if not Input.is_action_pressed("ui_mouse_click"):
		mouseIn = false
