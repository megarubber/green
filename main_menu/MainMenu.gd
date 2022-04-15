extends Node2D

# Node Referencing
onready var start_game = $BtnStartGame
onready var settings = $BtnSettings
onready var credits = $BtnCredits
onready var exit = $BtnExit
onready var transition = $TransitionBlock
onready var select = $SelectSoundEffect
onready var change = $ChangeSoundEffect

func _ready() -> void:
	if Global.g_music.get_stream() != load("res://audio/music/menu-2.ogg"):
		Global.play_music("res://audio/music/menu-2.ogg")
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
	select.play()
	enable_buttons(false)
	transition.fade_in()
	yield(transition, "finished")
	var _scene = get_tree().change_scene(path)

func _on_BtnStartGame_pressed() -> void:
	change_scene("res://levels/Level1.tscn")

func _on_BtnSettings_pressed() -> void:
	change_scene("res://main_menu/Settings.tscn")

func _on_BtnStartGame_focus_entered() -> void:
	change.play()

func _on_BtnSettings_focus_entered() -> void:
	change.play()

func _on_BtnCredits_focus_entered() -> void:
	change.play()

func _on_BtnExit_focus_entered() -> void:
	change.play()
