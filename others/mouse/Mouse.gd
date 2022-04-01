extends AnimatedSprite

func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	global_position = get_global_mouse_position()
	match Global.is_playing:
		true:
			play("aim")
			set_z_index(-6)
		false:
			play("default")
			set_z_index(0)
