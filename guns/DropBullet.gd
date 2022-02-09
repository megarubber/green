extends RigidBody2D

func _ready():
	set_as_toplevel(true)
	z_index = -1

func _on_Area2D_body_entered(_body):
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	queue_free()
	t.queue_free()
