extends Area2D

onready var skin = $Sprite
onready var collision = $CollisionShape2D

func _ready():
	skin.scale = Vector2(.5, .5)
	var square = skin.get_rect()
	collision.position = skin.position
	print(square)
	var spriteSize = skin.texture.get_size() * skin.scale * skin.scale
	print(spriteSize)
	collision.shape.set_extents(spriteSize - Vector2(1, 1))
