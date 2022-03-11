extends KinematicBody2D

# Constants
const SPEED = 350
const GRAVITY = 20
const FLOOR = Vector2(0, -1)

# Variables
var motion = Vector2()
var direction = 1

# Node Referencing
onready var sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var collider = $Collider
onready var lifebar = $Lifebar

func _physics_process(_delta) -> void:
	# Basic Movement and Gravity
	motion.x = SPEED * direction
	motion.y += GRAVITY
	motion = move_and_slide(motion, FLOOR)
	
	# Change direction
	if is_on_wall() || !raycast.is_colliding():
		direction = direction * -1
		raycast.position.x *= -1
		sprite.flip_h = !sprite.flip_h

func _on_Collider_area_entered(_area):
	lifebar.damage(10)
