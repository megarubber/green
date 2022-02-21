extends KinematicBody2D

# Constants
const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 250
const MAX_JUMP_HEIGHT = -850

# General Variables
var motion = Vector2()

# Nodes Referencing
onready var body_sprite = $BodySprite
onready var head_sprite = $HeadSprite
onready var animation = $AnimationPlayer
onready var screen_shake = $Camera/Screenshake

func _ready() -> void:
	z_index = -2

func execute_animation() -> void: # Player's animation function
	if is_on_floor():
		if motion.x != 0:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		if motion.y < 0:
			animation.play("jump")
		else:
			animation.play("fall")

func flip() -> void: # Flipping sprite function
	head_sprite.set_flip_h(get_global_mouse_position().x < global_position.x)
	
	if motion.x > 0:
		body_sprite.flip_h = false
	elif motion.x < 0:
		body_sprite.flip_h = true

func movement() -> void: # Player's movement function
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
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
	
	motion = move_and_slide(motion, UP)

func _physics_process(_delta: float) -> void: # Physics update
	movement()
	flip()
	execute_animation()
