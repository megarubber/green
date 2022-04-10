extends Node2D

# Constants
const DAMAGE = 10
const WAIT = 0.1

# Variables
var distance = 250
var follow = Vector2.ZERO
var founded = false
var speed = 15

# Node Referencing
onready var enemy = $Enemy
onready var body_s = $Enemy/Body
onready var head = $Enemy/Head
onready var collider = $Enemy/CollisionShape2D
onready var l_damage_area = $Enemy/LeftDamageArea
onready var r_damage_area = $Enemy/RightDamageArea
onready var lifebar = $Enemy/Lifebar
onready var anim = $Enemy/AnimationPlayer
onready var fire = $Enemy/Fire
onready var gun = $Enemy/GunSprite
onready var explosions = $Enemy/Explosion
onready var tween = $Tween
onready var eyes = $Enemy/Head/Eyes

func _ready() -> void:
	# When starts, it will play hide explosions
	explosions.visible = false
	_start_tween()

func _start_tween() -> void:
	var move_direction = Vector2.UP * distance
	var duration = move_direction.length() / float(speed * 16)
	
	tween.interpolate_property(
		self, 
		"follow", 
		Vector2.ZERO, 
		move_direction, 
		duration, 
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		WAIT
	)
	
	tween.interpolate_property(
		self, 
		"follow", 
		move_direction, 
		Vector2.ZERO,
		duration, 
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		duration + WAIT * 2
	)
	
	tween.start()

func animation() -> void:
	if !founded:
		eyes.play("default")
	else:
		eyes.play("angry")

func _process(_delta) -> void:
	animation()
	# Tests if player is dead
	if lifebar.getDeath():
		death()

func _physics_process(_delta) -> void:
	enemy.position = enemy.position.linear_interpolate(follow, 0.05)

# Function that runs when the enemy dies
func death() -> void:
	tween.stop_all()
	# Disable collision (bullet & tileset)
	l_damage_area.monitorable = false
	r_damage_area.monitorable = false
	l_damage_area.monitoring = false
	r_damage_area.monitoring = false
	collider.disabled = true
	
	# Explosions visible
	explosions.visible = true
	for explosion in explosions.get_children():
		# Each explosion will start play
		explosion.playing = true
	
	# Sprite & lifebar invisibles
	#lifebar.visible = false
	body_s.visible = false
	head.visible = false
	fire.visible = false
	gun.visible = false
	
	# Wait a time before delete enemy
	var t_d = Timer.new()
	t_d.set_wait_time(0.3)
	t_d.set_one_shot(true)
	self.add_child(t_d)
	t_d.start()
	yield(t_d, "timeout")
	queue_free()
	
# take damage
func take_damage() -> void:
	anim.play("flash")
	lifebar.damage(DAMAGE)

func _on_LeftDamageArea_area_entered(area) -> void:
	Global.hit_side = -1
	if area.is_in_group("bullets_player"):
		take_damage()
		area.queue_free()

func _on_RightDamageArea_area_entered(area) -> void:
	Global.hit_side = 1
	if area.is_in_group("bullets_player"):
		take_damage()
		area.queue_free()

func _on_DetectArea_body_entered(_body) -> void:
	founded = true

func _on_DetectArea_body_exited(_body) -> void:
	founded = false
