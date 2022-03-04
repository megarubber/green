extends Sprite

# Nodes Referencing
onready var child = get_children()[0]

# Constants
const MAX_EYE_UP = -3

# Variables
var max_dist = 15

func _process(_delta) -> void:
	# Eyes following mouse
	var mouse_pos = get_parent().position
	var dir = Vector2.ZERO.direction_to(mouse_pos)
	var dist = mouse_pos.length()
	#if mouse_pos.y < MAX_EYE_UP:
	#	dir.y = 0
	child.position = dir * min(dist, max_dist)
