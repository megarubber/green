extends CanvasLayer

# Node Referencing
onready var game_over_anim = $GameOver/AnimationPlayer
onready var game_over_screen = $GameOver
onready var start_anim = $StartLevel/AnimationPlayerStart
onready var start = $StartLevel
onready var level_name_label = $StartLevel/LevelName
onready var level_number_label = $StartLevel/LevelNumber

func _ready() -> void:
	var level_name_reference = get_tree().get_current_scene().get_name()
	match level_name_reference:
		"Level1":
			level_number_label.set_text("STAGE 01")
			level_name_label.set_text("Samueland City")
	var player = get_tree().get_current_scene().get_node("Player")
	player.connect("player_death", self, "_player_death")
	game_over_screen.visible = false
	start_anim.play("start")
	
func _player_death() -> void:
	game_over_screen.visible = true
	game_over_anim.play("fade_in")

func _on_AnimationPlayer_animation_finished(_anim_name) -> void:
	game_over_anim.stop()

func _on_AnimationPlayerStart_animation_finished(_anim_name) -> void:
	start.queue_free()

func _on_BtnTryAgain_pressed():
	var _result = get_tree().reload_current_scene()
