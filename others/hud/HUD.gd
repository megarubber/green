extends CanvasLayer

# Node Referencing
onready var black_screen_anim = $BlackScreen/AnimationPlayer
onready var black_screen = $BlackScreen

func _ready():
	var player = get_tree().get_current_scene().get_node("Player")
	player.connect("player_death", self, "_player_death")

func _player_death():
	black_screen.visible = true
	black_screen_anim.play("fade_in")

func _on_AnimationPlayer_animation_finished(_anim_name):
	#black_screen_anim.play("black")
	black_screen_anim.stop()
