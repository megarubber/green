extends Area2D

var flame_tilemap = false

func _process(_delta) -> void:
	if monitoring && monitoring:
		if get_overlapping_bodies():
			if get_overlapping_bodies()[0].get_name() == "Ground":
				flame_tilemap = true
			else:
				flame_tilemap = false
		else:
			flame_tilemap = false
	print(flame_tilemap)
