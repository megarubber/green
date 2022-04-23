extends Area2D

# Node Referencing
onready var anim = $AnimatedSprite
onready var sound_effect = $SoundEffect
onready var life_sfx = $LifeSoundEffect

func _ready() -> void:
	anim.play("default")
	anim.scale = Vector2(1, 1)

func _on_Coin_body_entered(body) -> void:
	if body.is_in_group("player"):
		anim.play("collected")
		sound_effect.play()
		anim.scale = Vector2(1.5, 1.5)
		Global.score += 100
		Global.coins += 1
		if Global.coins >= 100:
			life_sfx.play()
			Global.life += 1
			Global.coins = 0

func _on_AnimatedSprite_animation_finished() -> void:
	if anim.get_animation() == "collected":
		queue_free()
