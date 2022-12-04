extends Area2D

onready var skin = $Sprite
onready var collision = $CollisionShape2D

var mouseIn = false
var objeto = "Macaco"
var status = 0
var canBlock = false

func _ready():
	skin.scale = Vector2(.5, .5)
	collision.position = skin.position
	var spriteSize = skin.texture.get_size() * skin.scale * skin.scale
	collision.shape.set_extents(spriteSize - Vector2(1, 1))

# warning-ignore:unused_argument
func _process(delta):
	if status != 0:
		if canBlock:
			return
		if Input.is_action_just_released("ui_mouse_click"):
			canBlock = true
	if (mouseIn and Input.is_action_pressed("ui_mouse_click")):
		position = get_viewport().get_mouse_position()

func _on_Elefante_Teste_mouse_entered():
	mouseIn = true

func _on_Elefante_Teste_mouse_exited():
	if not Input.is_action_pressed("ui_mouse_click"):
		mouseIn = false

func set_status(stat):
	if stat == "Connected":
		status = 1

func get_objeto():
	return objeto
