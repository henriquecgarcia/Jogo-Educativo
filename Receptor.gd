extends Area2D

onready var skin = $Sprite
onready var collision = $CollisionShape2D

var mouseIn = false
var objeto = "Macaco"

func _ready():
	skin.scale = Vector2(.5, .5)
	var square = skin.get_rect()
	collision.position = skin.position
	var spriteSize = skin.texture.get_size() * skin.scale * skin.scale
	collision.shape.set_extents(spriteSize - Vector2(1, 1))

func _on_Receptor_area_entered(area):
	print(area.name)
	if not area.has_method("get_objeto"):
		return
	if (area.get_objeto() == objeto):
		area.set_status("Connected")
		area.position = position
		if not area.get_parent().has_method("set_display"):
			return
		area.get_parent().set_display(objeto)
