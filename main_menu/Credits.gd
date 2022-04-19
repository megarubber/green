extends Control

# Node Referencing
onready var transition = $TransitionBlock

func _ready() -> void:
	transition.fade_out()
	yield(get_tree().create_timer(23), "timeout")
	change_scene()

func change_scene() -> void:
	transition.fade_in()
	yield(transition, "finished")
	var _scene = get_tree().change_scene("res://main_menu/MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept") && !transition.is_transitioning:
		change_scene()
		
