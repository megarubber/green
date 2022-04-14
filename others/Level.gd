extends Node2D

# Node Referencing
onready var transition = $TransitionBlock

func _ready() -> void:
	transition.fade_out()
