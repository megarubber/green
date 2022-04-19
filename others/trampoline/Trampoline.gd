extends StaticBody2D

# Node Referecing
onready var anim = $Area/AnimationPlayer
onready var sfx = $SFX

func _ready() -> void:
	anim.play("default")

func _on_Area_area_entered(area) -> void:
	if area.is_in_group("drop"):
		anim.play("jump")
		var player = area.get_parent()
		player.motion.y = player.max_jump_height * 1.5
		player.jump_in_trampoline = true
		sfx.play()

func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "jump":
		anim.play("default")
