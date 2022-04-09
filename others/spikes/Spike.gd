extends Area2D

func _on_Left_area_entered(_area) -> void:
	Global.hit_side = -1

func _on_Right_area_entered(_area) -> void:
	Global.hit_side = 1
