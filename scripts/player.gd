extends CharacterBody2D

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("player_move_left", "player_move_right")
	velocity.x = direction * speed
	
	if(Input.is_action_just_pressed("player_jump")):
		velocity.y = -jump_force
	
#	if(velocity.x != 0):
#		animated_sprite.play("run")
#	else:
#		animated_sprite.play("idle")
		
	move_and_slide()
