extends RigidBody2D

func _ready():
	set_as_toplevel(true)
	z_index = -1

# When collide with ground, wait a time before be deleted
func _on_Area2D_body_entered(_body):
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	queue_free()
	t.queue_free()
