extends Sprite

# Nodes Referencing
onready var eyes = get_children()[0]
onready var player = get_tree().get_current_scene().get_node("Player")
onready var enemy = get_parent()

# Constants
const MAX_EYE_UP = -3

# Variables
var max_dist : int
var offset_x : int
var offset_y : int

func _ready():
	match get_parent().get_name():
		"MeleeEnemy":
			max_dist = 10
			offset_x = 9
			offset_y = 15
		"FollowerEnemy":
			max_dist = 5
			offset_x = 0
			offset_y = 20

func _process(_delta) -> void:
	# Eyes following player
	if enemy.founded:
		var eyes_pos = eyes.global_position
		var dir = eyes_pos.direction_to(player.global_position)
		var dist = eyes_pos.distance_to(player.global_position)
		eyes.position = dir * min(dist, max_dist)
		eyes.position.y += offset_y
		eyes.position.x += offset_x
