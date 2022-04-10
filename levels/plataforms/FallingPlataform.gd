extends KinematicBody2D

# Node Referencing
onready var anim = $AnimationPlayer
onready var collision = $CollisionShape2D

# Variables
var velocity = Vector2.ZERO
var gravity = 1020
var is_triggered = false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta : float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	collision.disabled = true
	
func _on_detect_player_body_entered(body) -> void:
	if body.is_in_group("player"):
		anim.play("shake")

func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "shake":
		set_physics_process(true)
