extends Area2D

# Variables
export var speed = 1500
var touched = false

# Nodes Referencing
onready var animation = $AnimationBullet

func _ready():
	animation.play("Default")
	set_as_toplevel(true)

func _process(delta):
	# Movement of bullet
	if !touched:
		position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _physics_process(_delta):
	if !touched:
		yield(get_tree().create_timer(0.01), "timeout")
		set_physics_process(false)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(_body):
	if !touched:
		touched = true
		animation.play("Explosion")
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()
