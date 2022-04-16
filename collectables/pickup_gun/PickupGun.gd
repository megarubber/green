extends Area2D

# Node Referencing
onready var sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

# Signal
signal player_entered(type)

# Enum
enum {BASIC, SPREAD, IMPULSE, PISTOL, AUTO_AIMING}

# General Variables
export(int) var type = BASIC

func _ready() -> void:
	match type:
		BASIC:
			sprite.play("gun1")
			collision_shape.position = Vector2(-0.5, -2)
		SPREAD:
			sprite.play("gun2")
			collision_shape.position = Vector2(0, -2.5)
		IMPULSE:
			sprite.play("gun3")
			collision_shape.position = Vector2(-0.5, -2.5)
		PISTOL:
			sprite.play("gun4")
			collision_shape.position = Vector2(-0.5, -2)
		AUTO_AIMING:
			sprite.play("gun5")
			collision_shape.position = Vector2(0, -2.5)
	sprite.scale = Vector2(1, 1)

func _on_AnimatedSprite_animation_finished() -> void:
	if sprite.get_animation() == "collected":
		queue_free()

func _on_PickupGun_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_entered", type)
		sprite.play("collected")
		sprite.scale = Vector2(1.5, 1.5)
