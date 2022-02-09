extends RigidBody2D

func _ready():
	set_as_toplevel(true)
	z_index = -1

func _on_Area2D_body_entered(_body):
	queue_free()
