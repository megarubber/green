extends Sprite

# Nodes Referencing
onready var eyes = get_children()[0]
onready var player = get_tree().get_current_scene().get_node("Player")

# Constants
const MAX_EYE_UP = -3

# Variables
var max_dist = 10

func _process(_delta) -> void:
	# Eyes following mouse
	var dist = global_position.distance_to(player.global_position)
	var dir = Vector2.direction_to(player.position)
	#if mouse_pos.y < MAX_EYE_UP:
	#	dir.y = 0
	eyes.position = dir * min(dist, max_dist)
