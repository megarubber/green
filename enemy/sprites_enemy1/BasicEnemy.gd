extends KinematicBody2D

# Constants
const SPEED = 350
const GRAVITY = 20
const FLOOR = Vector2(0, -1)

# Variables
var motion = Vector2()
var direction = 1

# Node Referencing
onready var animation = $AnimationPlayer
onready var sprite = $AnimatedSprite
onready var raycast = $RayCast2D

# When enemy created on level, it will start the run animation
func _ready() -> void:
	animation.play("run")

func _physics_process(_delta) -> void:
	# Basic Movement
	motion.x = SPEED * direction
	motion.y += GRAVITY
	motion = move_and_slide(motion, FLOOR)
	
	# Change direction
	if is_on_wall() || !raycast.is_colliding():
		direction = direction * -1
		raycast.position.x *= -1
		sprite.flip_h = !sprite.flip_h
