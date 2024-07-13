extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200

@onready var animated_sprite = $AnimatedSprite2D

var active = true

func _physics_process(delta):
	# FALLING
	if(!is_on_floor()):
		velocity.y += gravity * delta
		if(velocity.y > 500):
			velocity.y = 500
	var direction = 0
	if(active == true):
		# JUMPING
		if(Input.is_action_just_pressed("player_jump") && is_on_floor()):
			jump(jump_force)
		# RUNNING
		direction = Input.get_axis("player_move_left", "player_move_right") # returns -1 for left, 1 for right, else 0
	if(direction != 0):
		animated_sprite.flip_h = (direction == -1)
	velocity.x = direction * speed
	# PHYSICS HANDLING
	move_and_slide()
	update_animations(direction)

func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force

func update_animations(direction):
	if(is_on_floor()):
		if(direction == 0):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if(velocity.y < 0):
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
