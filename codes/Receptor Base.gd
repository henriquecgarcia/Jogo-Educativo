extends Area2D

onready var skin = $Sprite
onready var collision = $CollisionShape2D

var mouseIn = false
var objeto = "Sem Nome"

func Deploy(pos, objName, size = 0.5):
	var dir = Directory.new()
	if not dir.dir_exists("animais/"+objName):
		print("Path not found for animal: \"", objName, "\".")
		return
	var model = load("animals/"+objName+"/sombra.png")
	objeto = objName

	skin.set_texture(model)
	skin.scale = Vector2(size, size)
	
	var square = skin.get_rect()
	collision.position = skin.position
	var spriteSize = skin.texture.get_size() * skin.scale * skin.scale
	collision.shape.set_extents(spriteSize - Vector2(1, 1))

func _on_Receptor_Base_area_entered(area):
	if not area.has_method("get_objeto"):
		return
	if (area.get_objeto() == objeto):
		area.set_status("Connected")
		area.position = position
		if not area.get_parent().has_method("set_display"):
			return
		area.get_parent().set_display(objeto)
