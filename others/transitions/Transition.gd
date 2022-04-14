extends CanvasLayer

signal finished

# Node Referencing
onready var anim = $AnimationPlayer
onready var rectangles = $Rectangles

# Variables
var is_transitioning = false

# Play fade out transition
func fade_out() -> void:
	rectangles.visible = true
	anim.play_backwards("fade_in")
	is_transitioning = true

# Play fade in transition
func fade_in() -> void:
	rectangles.visible = true
	anim.play("fade_in")
	is_transitioning = true

func _on_AnimationPlayer_animation_finished(_anim_name) -> void:
	emit_signal("finished")
	rectangles.visible = false
	is_transitioning = false
