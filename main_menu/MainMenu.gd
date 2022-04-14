extends Node2D

# Node Referencing
onready var start_game = $BtnStartGame
onready var settings = $BtnSettings
onready var credits = $BtnCredits
onready var exit = $BtnExit

func _ready() -> void:
	start_game.grab_focus()

func _on_BtnExit_pressed() -> void:
	get_tree().quit()

func _on_BtnStartGame_pressed() -> void:
	var _scene = get_tree().change_scene("res://levels/Level1.tscn")
