extends KinematicBody2D

# Constants
const GRAVITY = 20
const FLOOR = Vector2(0, -1)

# Node Referencing
onready var wheel = $Wheel
onready var raycast = $RayCast2D
onready var gun = $GunSprite
onready var anim = $AnimationPlayer
onready var eyes = $Eyes

# Get Player Node
onready var player_pos = get_parent().get_node("Player")

# Variables
var founded = false
var motion = Vector2()
var direction = 1
var speed = 0

func _ready():
	# When created enemy, it's going to play default animation
	anim.play("default")

# Flipping and Animation function
func flip_and_animation() -> void:
	if motion.x != 0:
		wheel.playing = true
		if motion.x > 0:
			wheel.flip_h = false
		elif motion.x < 0:
			wheel.flip_h = true
	else:
		wheel.playing = false
	
	if !founded:
		eyes.play("default")
		if raycast.position.x < 0:
			gun.scale.x = -2.5
			gun.flip_v = true
		else:
			gun.scale.x = 2.5
			gun.flip_v = false
	else:
		eyes.play("angry")
		gun.scale.x = 2.5
		gun.flip_v = false

func _physics_process(_delta) -> void:
	# Follow player's position
	if founded:
		speed = 200
		if raycast.is_colliding():
			motion = (player_pos.position - position).normalized()
		else:
			motion.x = 0
		
		if (raycast.position.x > 1 && player_pos.global_position.x < raycast.global_position.x) || (raycast.position.x < 1 && player_pos.global_position.x > raycast.global_position.x):
			raycast.position.x *= -1
			direction *= -1
			
		# Basic Movement and Gravity
		motion.y += GRAVITY
		motion = move_and_slide(motion * speed)
	else:
		speed = 100
		# Basic Movement and Gravity
		motion.x = speed * direction
		motion.y += GRAVITY
		motion = move_and_slide(motion, FLOOR)
		
		# Change direction
		if is_on_wall() || !raycast.is_colliding():
			raycast.position.x *= -1
			direction *= -1

	flip_and_animation()

func _on_Area2D_body_entered(_body) -> void:
	founded = true

func _on_Area2D_body_exited(_body) -> void:
	founded = false
