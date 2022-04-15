extends Node2D

# Node Referencing
onready var start_game = $BtnStartGame
onready var settings = $BtnSettings
onready var credits = $BtnCredits
onready var exit = $BtnExit
onready var transition = $TransitionBlock

func _ready() -> void:
	enable_buttons(false)
	transition.fade_out()
	yield(transition, "finished")
	enable_buttons(true)
	start_game.grab_focus()

func enable_buttons(value : bool) -> void:
	start_game.disabled = !value
	settings.disabled = !value
	credits.disabled = !value
	exit.disabled = !value

func _on_BtnExit_pressed() -> void:
	get_tree().quit()

func change_scene(path : String) -> void:
	enable_buttons(false)
	transition.fade_in()
	yield(transition, "finished")
	var _scene = get_tree().change_scene(path)

func _on_BtnStartGame_pressed() -> void:
	change_scene("res://levels/Level1.tscn")

func _on_BtnSettings_pressed() -> void:
	change_scene("res://main_menu/Settings.tscn")
