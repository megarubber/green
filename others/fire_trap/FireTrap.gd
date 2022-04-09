extends StaticBody2D

# Node Referencing
onready var sprite = $AnimatedSprite
onready var left_col = $LeftFire
onready var right_col = $RightFire

# Get Player Node
onready var player = get_tree().get_current_scene().get_node("Player")

func _ready() -> void:
	call_monitorable(false)

func call_monitorable(value : bool) -> void:
	left_col.monitorable = value
	left_col.monitoring = value
	right_col.monitorable = value
	right_col.monitoring = value

func _on_StartTimer_timeout() -> void:
	sprite.play("fire")
	call_monitorable(true)

func _on_StopTimer_timeout()  -> void:
	sprite.play("default")
	call_monitorable(false)

func _process(_delta) -> void:
	if left_col.monitoring:
		if left_col.get_overlapping_areas() && !player.hit:
			if left_col.get_overlapping_areas()[0].get_name() == "DamageArea":
				player.take_damage(15)
				Global.hit_side = -1
	elif right_col.monitoring:
		if right_col.get_overlapping_areas() && !player.hit:
			if right_col.get_overlapping_areas()[0].get_name() == "DamageArea":
				player.take_damage(15)
				Global.hit_side = 1
