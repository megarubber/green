extends Area2D

func _on_Checkpoint_body_entered(body):
	if body.is_in_group("player"):
		body.hit_checkpoint()
