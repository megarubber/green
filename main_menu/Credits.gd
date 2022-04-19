extends Control

# Node Referencing
onready var transition = $TransitionBlock

func _ready() -> void:
	Global.play_music("res://audio/music/credits.ogg")
	transition.fade_out()
	var t_d = Timer.new()
	t_d.set_wait_time(20.3)
	t_d.set_one_shot(true)
	self.add_child(t_d)
	t_d.start()
	yield(t_d, "timeout")
	change_scene()

func change_scene() -> void:
	transition.fade_in()
	yield(transition, "finished")
	var _scene = get_tree().change_scene("res://main_menu/MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept") && !transition.is_transitioning:
		change_scene()
		
