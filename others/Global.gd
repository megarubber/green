extends Node2D

# Player
var hit_side
var coins = 0
var life = 3
var checkpoint_position = Vector2.ZERO
var is_checkpoint_hitted = false

# Level Name
onready var current_scene_name = get_tree().get_current_scene().get_name()

# Game State
var is_playing = false
