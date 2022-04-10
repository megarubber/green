extends KinematicBody2D

# Constants
const GRAVITY = 20
const FLOOR = Vector2(0, -1)
const SPEED_FOUNDED = 200
const SPEED_NORMAL = 100
const GUN_MIRROR_SIZE = 2.5
const DAMAGE = 10

# Node Referencing
onready var wheel = $Wheel
onready var raycast = $RayCast2D
onready var gun = $GunSprite
onready var anim = $AnimationPlayer
onready var head = $Head
onready var eyes = $Head/Eyes
onready var lifebar = $Lifebar
onready var collider = $CollisionShape2D
onready var l_damage_area = $LeftDamageArea
onready var r_damage_area = $RightDamageArea
onready var explosions = $Explosion
onready var body_s = $Body
onready var detect_area = $DetectArea

# Get Player Node
onready var player_pos = get_tree().get_current_scene().get_node("Player")

# Variables
var founded = false
var motion = Vector2()
var direction = 1
var speed = 0
var timer = null
var delay = 0.3

func _ready() -> void:
	# When created enemy, it will play default animation
	anim.play("default")
	# Explosions hide
	explosions.visible = false
	
	# Creating Timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_complete") 
	add_child(timer)

# Flipping and Animation function
func flip_and_animation() -> void:
	if motion.x != 0:
		wheel.playing = true
		if motion.x > 0:
			wheel.flip_h = false
		elif motion.x < 0:
			wheel.flip_h = true
	else:
		wheel.playing = false
	
	if !founded:
		eyes.play("default")
		if raycast.position.x < 0:
			gun.scale.x = -GUN_MIRROR_SIZE
			gun.flip_v = true
		else:
			gun.scale.x = GUN_MIRROR_SIZE
			gun.flip_v = false
	else:
		eyes.play("angry")
		gun.scale.x = GUN_MIRROR_SIZE
		gun.flip_v = false

func _physics_process(_delta) -> void:
	# Follow player's position
	# If enemy founded player
	if founded && !lifebar.getDeath():
		speed = SPEED_FOUNDED
		if raycast.is_colliding():
			motion = (player_pos.global_position - global_position).normalized()
		else:
			motion.x = 0
		
		if (raycast.position.x > 1 && player_pos.global_position.x < raycast.global_position.x) || (raycast.position.x < 1 && player_pos.global_position.x > raycast.global_position.x):
			raycast.position.x *= -1
			direction *= -1
			
		# Basic Movement and Gravity
		motion.y += GRAVITY
		motion = move_and_slide(motion * speed)
	# Else: enemy runs like the basic enemy
	elif !founded && !lifebar.getDeath():
		speed = SPEED_NORMAL
		# Basic Movement and Gravity
		motion.x = speed * direction
		motion.y += GRAVITY
		motion = move_and_slide(motion, FLOOR)
		
		# Change direction
		if is_on_wall() || !raycast.is_colliding():
			raycast.position.x *= -1
			direction *= -1
	else:
		death()
	# Call flip and animation function
	flip_and_animation()

# Function that runs when the enemy dies
func death():
	# Disable collision (bullet & tileset)
	l_damage_area.monitorable = false
	r_damage_area.monitorable = false
	l_damage_area.monitoring = false
	r_damage_area.monitoring = false
	collider.disabled = true
	detect_area.monitorable = false
	detect_area.monitoring = false
	
	# Explosions visible
	explosions.visible = true
	for explosion in explosions.get_children():
		# Each explosion will start play
		explosion.playing = true
	
	# Sprite & lifebar invisibles
	#lifebar.visible = false
	gun.visible = false
	head.visible = false
	wheel.visible = false
	body_s.visible = false
	
	# Wait a time before delete enemy
	var t_d = Timer.new()
	t_d.set_wait_time(0.3)
	t_d.set_one_shot(true)
	self.add_child(t_d)
	t_d.start()
	yield(t_d, "timeout")
	queue_free()

# When timer ends
func on_timeout_complete() -> void:
	anim.play("default")

# take damage
func take_damage() -> void:
	anim.play("flash")
	lifebar.damage(DAMAGE)

func _on_LeftDamageArea_area_entered(area) -> void:
	Global.hit_side = -1
	# When bullet entered at left damage area
	if area.is_in_group("bullets_player"):
		take_damage()
		timer.start()

func _on_RightDamageArea_area_entered(area) -> void:
	Global.hit_side = 1
	# When bullet entered at right damage area
	if area.is_in_group("bullets_player"):
		take_damage()
		timer.start()

func _on_DetectArea_body_entered(body) -> void:
	if body.is_in_group("player"):
		founded = true

func _on_DetectArea_body_exited(body) -> void:
	if body.is_in_group("player"):
		founded = false
