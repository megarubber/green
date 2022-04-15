extends Control

func _ready() -> void:
	Global.play_music("res://audio/sound-effects/intro-game-audio.wav")

func _on_VideoPlayer_finished() -> void:
	var _scene = get_tree().change_scene("res://main_menu/TitleScreen.tscn")
