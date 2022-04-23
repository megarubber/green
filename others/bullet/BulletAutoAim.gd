extends Area2D

# Variables
export var speed = 800
var touched = false
var in_area = false
var timer = null
var delay = 0.7
var target = null

# Nodes Referencing
onready var animation = $AnimationBullet
onready var collision = $CollisionShape2D
onready var sprite = $Sprite
onready var explosion = $Explosion

# Get Player Node
onready var player = get_tree().get_current_scene().get_node("Player")

func _ready() -> void:
	animation.play("Default")
	set_as_toplevel(true)
	sprite.set_z_index(-3)

func _process(delta: float) -> void:
	# Movement of bullet
	if !touched:
		if target && is_instance_valid(target):
			look_at(target.global_position)
		elif target && !is_instance_valid(target):
			destroy_bullet()
		position += (Vector2.RIGHT * speed).rotated(rotation) * delta
	
func _physics_process(_delta) -> void:
	if !touched:
		# Creating timer
		var t_d = Timer.new()
		t_d.set_wait_time(0.01)
		t_d.set_one_shot(true)
		self.add_child(t_d)
		t_d.start()
		yield(t_d, "timeout")
		t_d.queue_free()
		
		set_physics_process(false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func destroy_bullet() -> void:
	touched = true
	collision.set_deferred("disabled", true)
	animation.play("Explosion")
	#explosion.play()

func _on_Bullet_body_entered(body) -> void:
	if !touched:
		if body.is_in_group("tilemap"):
			destroy_bullet()
		
		if body.is_in_group("enemy"):
			touched = true
			Global.score += 75
			queue_free()

func _on_DamageArea_area_entered(_area) -> void:
	if position.x < player.global_position.x:	
		Global.hit_side = 1
	else:
		Global.hit_side = -1

func _on_AnimationBullet_animation_finished(anim_name) -> void:
	if anim_name == "Explosion":
		queue_free()

func _on_aim_area_body_entered(body) -> void:
	if body.is_in_group("enemy"):
		target = body
