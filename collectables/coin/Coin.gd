extends Area2D

# Node Referencing
onready var anim = $AnimatedSprite

func _ready() -> void:
	anim.play("default")
	anim.scale = Vector2(1, 1)

func _on_Coin_body_entered(_body) -> void:
	anim.play("collected")
	anim.scale = Vector2(1.5, 1.5)

func _on_AnimatedSprite_animation_finished() -> void:
	if anim.get_animation() == "collected":
		queue_free()
