extends CanvasLayer

# Node Referencing
onready var game_over_anim = $GameOver/AnimationPlayer
onready var game_over_screen = $GameOver
onready var start_anim = $StartLevel/AnimationPlayerStart
onready var start = $StartLevel
onready var level_name_label = $StartLevel/LevelName
onready var level_number_label = $StartLevel/LevelNumber
onready var pause_screen = $Pause
onready var pause_screen_anim = $Pause/AnimationPlayerPause

func _ready() -> void:
	var level_name_reference = Global.current_scene_name
	match level_name_reference:
		"Level1":
			level_number_label.set_text("STAGE 01")
			level_name_label.set_text("Samueland City")
	var player = get_tree().get_current_scene().get_node("Player")
	player.connect("player_death", self, "_player_death")
	invisible_special_screens()
	start.visible = true
	start_anim.play("start")

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_pause"):
		pause_game(true)

func pause_game(value : bool) -> void:
	if value:
		get_tree().paused = true
		Global.is_playing = false
		pause_screen.visible = true
		pause_screen_anim.play("paused")
	else:
		pause_screen_anim.play_backwards("paused")
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = false
		Global.is_playing = true
		pause_screen.visible = false

func invisible_special_screens() -> void:
	game_over_screen.visible = false
	pause_screen.visible = false

func _player_death() -> void:
	game_over_screen.visible = true
	game_over_anim.play("fade_in")

func _on_AnimationPlayer_animation_finished(_anim_name) -> void:
	game_over_anim.stop()

func _on_AnimationPlayerStart_animation_finished(_anim_name) -> void:
	start.queue_free()

func _on_BtnTryAgain_pressed() -> void:
	var _result = get_tree().reload_current_scene()

func _on_BtnResume_pressed():
	pause_game(false)
