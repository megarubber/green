extends Node2D

var hit_side
var coins = 0
var checkpoint_position = Vector2.ZERO
var is_checkpoint_hitted = false
onready var current_scene_name = get_tree().get_current_scene().get_name()

var is_playing = false
