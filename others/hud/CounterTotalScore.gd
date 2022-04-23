extends Label

func _process(_delta) -> void:
	set_text("TOTAL SCORE: " + String(Global.score) + " x "  + String(Global.life) + " = " + String(Global.total_score))
