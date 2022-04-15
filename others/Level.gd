extends Node2D

# Node Referencing
onready var transition = $TransitionBlock

func _ready() -> void:
	transition.fade_out()
	Global.play_music("res://audio/music/level1.ogg")
