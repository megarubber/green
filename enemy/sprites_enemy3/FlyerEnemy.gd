extends Node2D

# Constants
const SPEED = 15
const DAMAGE = 10
const WAIT = 0.1

# Variables
var distance = 250
var opa : bool

# Node Referencing
onready var enemy = $Enemy
onready var sprite = $Enemy/AnimatedSprite
onready var collider = $Enemy/CollisionShape2D
onready var l_damage_area = $Enemy/LeftDamageArea
onready var r_damage_area = $Enemy/RightDamageArea
onready var lifebar = $Enemy/Lifebar
onready var anim = $Enemy/AnimationPlayer
onready var fire = $Enemy/Fire
onready var explosions = $Enemy/Explosion
onready var tween = $Tween

func _ready() -> void:
	# When starts, it will play hide explosions
	explosions.visible = false
	_start_tween()

func _eae():
	print("eae")

func _start_tween():
	var move_direction = Vector2.UP * distance
	var duration = move_direction.length() / float(SPEED * 16)
	
	tween.interpolate_property(
		enemy, 
		"position", 
		Vector2.ZERO, 
		move_direction, 
		duration, 
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		WAIT
	)
	
	tween.interpolate_property(
		enemy, 
		"position", 
		move_direction, 
		Vector2.ZERO,
		duration, 
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		duration + WAIT * 2
	)
	
	tween.start()

func animation() -> void:
	if enemy.position.y == -distance:
		sprite.play("down")
	elif enemy.position.y == 0:
		sprite.play("up")

func _process(_delta) -> void:
	animation()
	
	# Tests if player is dead
	if lifebar.getDeath():
		death()

	
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
	sprite.visible = false
	fire.visible = false
	
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

func _on_LeftDamageArea_area_entered(area):
	Global.hit_side = -1
	if area.is_in_group("bullets_player"):
		take_damage()
		area.queue_free()

func _on_RightDamageArea_area_entered(area):
	Global.hit_side = 1
	if area.is_in_group("bullets_player"):
		take_damage()
		area.queue_free()
