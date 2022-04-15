extends Node2D

# Constants
const WAIT_DURATION = 1.0

# Node Referencing
onready var start_timer = $Logo/StartTimer
onready var logo = $Logo
onready var label_anim = $LabelSpacebar/AnimationPlayer
onready var tween = $Logo/Tween
onready var transition_block = $TransitionBlock
onready var transition_dissolve = $TransitionDissolve
onready var background = $Background
onready var sound_effect = $SpacebarSoundEffect

# Variables
onready var positions_tween = [
	Vector2(logo.position.x, logo.position.y + 10), 
	Vector2(logo.position.x, logo.position.y - 10)
]

func _ready() -> void:
	Global.play_music("res://audio/music/menu-2.ogg")
	transition_dissolve.fade_out()
	label_anim.play("default")
	_start_tween()

func _start_tween() -> void:
	tween.interpolate_property(
		logo, 
		"position", 
		positions_tween[0],
		positions_tween[1],
		1,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.start()

func _on_StartTimer_timeout() -> void:
	logo.play("highlight")

func _on_Logo_animation_finished() -> void:
	if logo.get_animation() == "highlight":
		logo.play("default")

func _on_Tween_tween_completed(_object, _key) -> void:
	positions_tween.invert()
	_start_tween()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		sound_effect.play()
		transition_block.fade_in()
		yield(transition_block, "finished")
		var _scene = get_tree().change_scene("res://main_menu/MainMenu.tscn")
