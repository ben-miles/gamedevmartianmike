extends ParallaxBackground

@export var bg_texture: CompressedTexture2D = preload("res://assets/textures/bg/Blue.png")
@export var scroll_speed = 15

@onready var sprite = $ParallaxLayer/Sprite2D

func _process(delta):
	sprite.region_rect.position += delta * Vector2(scroll_speed, scroll_speed)
	# Prevent region position from becoming an unmanagably huge int value
	if sprite.region_rect.position >= Vector2(64, 64):
		sprite.region_rect.position >= Vector2.ZERO
