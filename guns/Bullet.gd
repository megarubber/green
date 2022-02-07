extends Area2D

# Variables
export var speed = 1500

# Nodes Referencing
onready var bullet_sprite = $Sprite

func _ready():
	bullet_sprite.frame = 0
	set_as_toplevel(true)

func _process(delta):
	# Movement of bullet
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _physics_process(_delta):
	yield(get_tree().create_timer(0.01), "timeout")
	bullet_sprite.frame = 1 # Change sprite to light from bullet
	set_physics_process(false)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(_body):
	queue_free()
