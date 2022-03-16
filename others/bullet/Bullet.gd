extends Area2D

# Variables
export var speed = 1500
var touched = false
var in_area = false
var timer = null
var delay = 0.7

# Nodes Referencing
onready var animation = $AnimationBullet
onready var collision = $CollisionShape2D

func _ready() -> void:
	# Creating Timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_complete") 
	add_child(timer)
	
	animation.play("Default")
	set_as_toplevel(true)

# When timer ends
func on_timeout_complete() -> void:
	queue_free()

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

func _on_Bullet_body_entered(body) -> void:
	if !touched:
		touched = true
	
		if body.is_in_group("tilemap"):
			collision.set_deferred("disabled", true)
			animation.play("Explosion")
			timer.start()
		
		if body.is_in_group("enemy") || body.is_in_group("player"):
			queue_free()
