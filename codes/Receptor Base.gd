extends Area2D

onready var collision = $CollisionShape2D
onready var skin = $Sprite

var objeto = "Sem Nome"
var foundObj = null
var placed = false

func Deploy(pos, objName):
	var dir = Directory.new()
	if not dir.dir_exists("animais/"+objName):
		print("Path not found for animal: \"", objName, "\".")
		return false
	var model = load("res://animais/"+objName+"/sombra.png")
	if not model:
		print("Model not found for "+objName+"...")
		return false

	objeto = objName
	skin.texture = model
	
	var size = Vector2(296/2, 215/2) / skin.texture.get_size() # Pro elefante, isso deve ser 0.5
	#var size = 0.5
	
	size = min(size[1], size[0])
	
	skin.scale = Vector2(size, size)
	
	collision.position = skin.position
	
	#var spriteSize = skin.texture.get_size() * size * size * size
	#collision.shape.set_extents(spriteSize - Vector2(1, 1))
	#collision.shape.set_extents(spriteSize)
	
	position = pos
	return true

# warning-ignore:unused_argument
func _process(delta):
	if foundObj == null:
		return
	
	if placed or not foundObj.is_mouseIn():
		return
	
	if not Input.is_action_just_released("ui_mouse_click"):
		return

	placed = true
	
	foundObj.set_status("Connected")
	foundObj.position = position
	if not foundObj.get_parent().get_parent().has_method("set_display"):
		return
	foundObj.get_parent().get_parent().set_display(objeto)

func _on_Receptor_Base_area_entered(area):
	if not area.has_method("get_objeto"):
		return
	if (area.get_objeto() == objeto):
		foundObj = area

func _on_Receptor_Base_area_exited(area):
	if not area.has_method("get_objeto"):
		return
	if (area.get_objeto() == objeto):
		foundObj = null
