extends Control

# Node Referencing
onready var transition = $TransitionDissolve

func _ready() -> void:
	Global.play_music("res://audio/music/game-over.ogg")
	transition.fade_out()
	yield(get_tree().create_timer(9), "timeout")
	transition.fade_in()
	yield(transition, "finished")
	Global.reset_all()
	var _scene = get_tree().change_scene("res://main_menu/Intro.tscn")
