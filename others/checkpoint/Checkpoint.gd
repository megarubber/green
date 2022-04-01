extends Area2D

# Node Referencing
onready var anim = $AnimationPlayer
onready var label = $Label

func _ready() -> void:
	label.visible = false
	if Global.is_checkpoint_hitted:
		anim.play("already_checked")

func _on_Checkpoint_body_entered(body) -> void:
	if body.is_in_group("player") && !Global.is_checkpoint_hitted:
		body.hit_checkpoint()
		label.visible = true
		anim.play("checked")
