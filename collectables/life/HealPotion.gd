extends Area2D

# Constants
const HEAL = 10

# Node Referencing
onready var anim = $AnimatedSprite

# Get Lifebar
onready var lifebar = get_tree().get_current_scene().get_node("HUD/Health/Lifebar")

func _ready() -> void:
	anim.play("default")
	anim.scale = Vector2(2.4, 2.4)

func _on_AnimatedSprite_animation_finished() -> void:
	if anim.get_animation() == "collected":
		queue_free()

func _on_HealPotion_body_entered(body) -> void:
	if body.is_in_group("player"):
		anim.play("collected")
		anim.scale = Vector2(1.5, 1.5)
		Global.score += 100
		var limit_life = lifebar.life + HEAL
		if limit_life <= lifebar.lifeMax:
			lifebar.heal(HEAL)
