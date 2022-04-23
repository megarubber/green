extends Label

func _process(_delta) -> void:
	set_text("LIFE: " + String(Global.life))
