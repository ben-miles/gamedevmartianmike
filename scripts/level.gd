extends Node2D

@export var next_level: PackedScene = null
@export var level_time = 12
@export var is_final_level: bool = false

@onready var start = $Start
@onready var exit = $Exit
@onready var deathzone = $Deathzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var player = null
var timer_node = null
var time_left
var win = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.global_position
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.connect("touched_player", _on_trap_touched_player)
	exit.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	# TIMER
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	timer_node.name = "Level Timer"
	add_child(timer_node)
	timer_node.start()

func _process(delta):
	if(Input.is_action_just_pressed("quit")):
		get_tree().quit()
	elif(Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body):
	reset_player()

func _on_level_timer_timeout():
	if win == false: 
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_player()

func _on_trap_touched_player():
	reset_player()
	
func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.global_position
	time_left = level_time
	hud.set_time_label(time_left)
	
func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			#load next level
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
