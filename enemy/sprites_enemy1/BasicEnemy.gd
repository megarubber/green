extends KinematicBody2D

# Constants
const SPEED = 350
const GRAVITY = 20
const FLOOR = Vector2(0, -1)

# Variables
var motion = Vector2()
var direction = 1

# Node Referencing
onready var sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var collider = $CollisionShape2D
onready var damage_area = $DamageArea
onready var lifebar = $Lifebar
onready var anim = $AnimationPlayer
onready var wheel = $Wheel
onready var explosions = $Explosion

func _ready() -> void:
	# When starts, it will play hide explosions
	explosions.visible = false

func _physics_process(_delta) -> void:
	# Tests if player is dead
	if !lifebar.getDeath():
		# Basic Movement and Gravity
		motion.x = SPEED * direction
		motion.y += GRAVITY
		motion = move_and_slide(motion, FLOOR)
			
		# Change direction
		if is_on_wall() || !raycast.is_colliding():
			direction = direction * -1
			raycast.position.x *= -1
			sprite.flip_h = !sprite.flip_h
	else:
		death()

# Function that runs when the enemy dies
func death():
	# Disable collision (bullet & tileset)
	damage_area.monitorable = false
	damage_area.monitoring = false
	collider.disabled = true
	
	# Explosions visible
	explosions.visible = true
	for explosion in explosions.get_children():
		# Each explosion will start play
		explosion.playing = true
	
	# Sprite & lifebar invisibles
	#lifebar.visible = false
	sprite.visible = false
	wheel.visible = false
	
	# Wait a time before delete enemy
	var t_d = Timer.new()
	t_d.set_wait_time(0.3)
	t_d.set_one_shot(true)
	self.add_child(t_d)
	t_d.start()
	yield(t_d, "timeout")
	queue_free()

# When bullet entered on damage area
func _on_DamageArea_area_entered(_area):
	anim.play("flash")
	# take damage
	lifebar.damage(10)
