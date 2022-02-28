extends KinematicBody2D

# Constants
const SPEED = 200
const GRAVITY = 20

# Node Referencing
onready var wheel = $Wheel
onready var raycast = $RayCast2D

# Get Player Node
onready var player_pos = get_parent().get_node("Player")

# Variables
var founded = false
var motion = Vector2()

func flip() -> void:
	if motion.x > 0:
		wheel.flip_h = false
	elif motion.x < 0:
		wheel.flip_h = true

func _physics_process(_delta) -> void:
	if player_pos:
		# Follow player's position
		if founded && raycast.is_colliding():
			wheel.playing = true
			motion = (player_pos.position - position).normalized()
		else:
			motion.x = 0
			wheel.playing = false
		
		if (raycast.position.x > 1 && player_pos.global_position.x < raycast.global_position.x) || (raycast.position.x < 1 && player_pos.global_position.x > raycast.global_position.x):
			raycast.position.x *= -1
		
		# Gravity
		motion.y += GRAVITY
		
		# Basic Movement
		move_and_slide(motion * SPEED)
		flip()


func _on_Area2D_body_entered(_body) -> void:
	founded = true

func _on_Area2D_body_exited(_body) -> void:
	founded = false
