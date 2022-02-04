extends KinematicBody2D

# Constants
const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const MAX_JUMP_HEIGHT = -500

# General Variables
var motion = Vector2()

# Nodes Referencing
onready var player_sprite = $Sprite

func movement(delta) -> void: # Player's movement function
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		player_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		player_sprite.flip_h = true
	else:
		motion.x = 0
		friction = true
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = MAX_JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
		if Input.is_action_just_released("ui_up") && motion.y < 0:
			motion.y = 0
	
	var moving = move_and_slide(motion, UP)
	print(moving)
	
func _physics_process(delta):
	movement(delta)
