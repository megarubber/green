extends Sprite

# Nodes Referencing
onready var eyes = get_children()[0]
onready var animation = $AnimationEyes

# Constants
const MAX_EYE_UP = -3

# Variables
var max_dist = 2

func _ready() -> void:
	animation.play("blinking")

func _process(_delta) -> void:
	# Eyes following mouse
	var mouse_pos = get_local_mouse_position()
	var dir = Vector2.ZERO.direction_to(mouse_pos)
	var dist = mouse_pos.length()
	if mouse_pos.y < MAX_EYE_UP:
		dir.y = 0
	eyes.position = dir * min(dist, max_dist)
