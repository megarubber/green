extends Area2D

# Node Referencing
onready var sprite = $AnimatedSprite

# Signal
signal player_entered(type)

# Enum
enum {SPEED, JUMP, GUN}

# General Variables
export(int) var type = SPEED

func _ready() -> void:
	match type:
		SPEED:
			sprite.play("speed")
		JUMP:
			sprite.play("jump")
		GUN:
			sprite.play("gun")
	sprite.scale = Vector2(1, 1)

func _on_Coin_body_entered(body) -> void:
	if body.is_in_group("player"):
		emit_signal("player_entered", type)
		sprite.play("collected")
		sprite.scale = Vector2(0.7, 0.7)

func _on_AnimatedSprite_animation_finished() -> void:
	if sprite.get_animation() == "collected":
		queue_free()
