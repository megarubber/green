extends Label

func _process(_delta) -> void:
	set_text("SCORE: " + String(Global.score))
