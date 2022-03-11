extends Area2D

# Variables
export var speed = 1500
var touched = false

# Nodes Referencing
onready var animation = $AnimationBullet
onready var collision = $CollisionShape2D

func _ready() -> void:
	animation.play("Default")
	set_as_toplevel(true)

func _process(delta: float) -> void:
	# Movement of bullet
	if !touched:
		position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _physics_process(_delta) -> void:
	if !touched:
		yield(get_tree().create_timer(0.01), "timeout")
		set_physics_process(false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_Bullet_body_entered(_body) -> void:
	if !touched:
		collision.disabled = true
		touched = true
		animation.play("Explosion")
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()
		return
