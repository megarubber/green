extends KinematicBody2D

# Signal
signal player_death()

# Constants
const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const DAMAGE = 10
const MAX_SPEED_NORMAL = 350
const MAX_SPEED_POWERUP = 550
const MAX_JUMP_HEIGHT_NORMAL = -850
const MAX_JUMP_HEIGHT_POWERUP = -1000
const DROP_THRU_BIT = 1

# General Variables
var motion = Vector2()
export var knockback = 15000
export var knockup = 1700
export var start_position_level = Vector2()
var hit = false
var max_speed = MAX_SPEED_NORMAL
var max_jump_height = -850
var can_fly = true
var jump_in_trampoline = false

# Nodes Referencing
onready var body_sprite = $BodySprite
onready var head_sprite = $HeadSprite
onready var gun = $GunSprite
onready var anim = $AnimationPlayer
onready var screen_shake = $Camera/Screenshake
onready var damage_area = $DamageArea
onready var anim_eyes = $HeadSprite/AnimationEyes
onready var wings = $Wings
onready var drop = $DropPlataformArea
onready var collider = $CollisionShape2D
onready var ring = $Ring

# Referencing lifebar from HUD
onready var lifebar = get_tree().get_current_scene().get_node("HUD/Health/Lifebar")

func _ready() -> void:
	if Global.is_checkpoint_hitted:
		position = Global.checkpoint_position
	else:
		position = start_position_level
	Global.is_playing = true
	wings.visible = false
	ring.visible = false
	z_index = -2
	for powerup in get_parent().get_node("PowerUps").get_children():
		powerup.connect("player_entered", self, "_powerup")

func animation() -> void: # Player's animation function
	if is_on_floor() && !lifebar.getDeath():
		if motion.x != 0:
			anim.play("run")
		else:
			anim.play("idle")
	elif !is_on_floor() && !lifebar.getDeath():
		if motion.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
			jump_in_trampoline = false

func flip() -> void: # Flipping sprite function
	if !lifebar.getDeath():
		head_sprite.set_flip_h(get_global_mouse_position().x < global_position.x)
	else:
		head_sprite.set_flip_h(false)
	
	if motion.x > 0:
		body_sprite.flip_h = false
	elif motion.x < 0:
		body_sprite.flip_h = true

func movement() -> void: # Player's movement function
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_down"):
		set_collision_mask_bit(DROP_THRU_BIT, false)
	
	if !lifebar.getDeath():
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x + ACCELERATION, max_speed)
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x - ACCELERATION, -max_speed)
		else:
			motion.x = 0
			friction = true
			
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = max_jump_height
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.2)
		else:
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.05)
			if !jump_in_trampoline && Input.is_action_just_released("ui_up") && motion.y < 0:
				motion.y = 0
	else:
		death()
		friction = true
	motion = move_and_slide(motion, UP)

func death() -> void:
	motion.x = 0
	if can_fly:	
		motion.y = min(0, motion.y - 30)
		anim_eyes.play("damage")
		anim.play("dead")
	if !wings.visible:
		Global.life -= 1
		emit_signal("player_death")
		wings.visible = true
		ring.visible = true
		deactivate_all_colliders()
		Global.is_playing = false
	
func deactivate_all_colliders() -> void:
	drop.monitorable = false
	drop.monitoring = false
	damage_area.monitorable = false
	damage_area.monitoring = false
	collider.disabled = true

func _physics_process(_delta: float) -> void: # Physics update
	movement()
	
func _process(_delta: float) -> void:
	flip()
	animation()
	debug_inputs()
	
func debug_inputs():
	if Input.is_key_pressed(KEY_KP_1):
		lifebar.damage(50)

func _on_DamageArea_area_entered(area) -> void:
	var type = area.get_groups()
	if !hit:
		var strength = 0
		match type[0]:
			"basic_enemy":
				strength = 10
			"bullets_enemy":
				strength = 5
			"sword_enemy": # Executing in MeleeEnemy script (I don't know why)
				strength = 8
			"small_flyer_enemy":
				strength = 5
			"fire_trap":
				strength = 15
			"spike":
				strength = 10
				if lifebar.life > strength:	
					motion.y = lerp(0, -knockup, 0.6)
			"fallzone":
				strength = lifebar.lifeMax
				can_fly = false
			"chainsaw":
				strength = 20
			_:
				strength = 0
		if strength > 0:
			take_damage(strength)
	else:
		match type[0]:
			"fallzone":
				take_damage(lifebar.lifeMax)
				can_fly = false

func player_visible(value : bool) -> void:
	body_sprite.visible = value
	head_sprite.visible = value
	gun.visible = value

func take_damage(strength : int) -> void:
	var knock_side = knockback * Global.hit_side
	motion.x -= lerp(motion.x, -knock_side, 0.1)
	#motion.y = lerp(0, -knockup, 0.6)
	motion = move_and_slide(motion, UP)
	hit = true
		
	if lifebar != null:
		lifebar.damage(strength)
		if !lifebar.getDeath():
			blink()

func blink() -> void:
	anim_eyes.play("damage")
	player_visible(false)
	yield(get_tree().create_timer(0.05), "timeout")
	player_visible(true)
	yield(get_tree().create_timer(0.07), "timeout")
	player_visible(false)
	anim_eyes.play("blinking")
	for _i in range(6):
		yield(get_tree().create_timer(0.1), "timeout")
		player_visible(true)
		yield(get_tree().create_timer(0.1), "timeout")
		player_visible(false)
	player_visible(true)
	hit = false

func _powerup(type):
	match type:
		0: # Speed
			max_speed = MAX_SPEED_POWERUP
			yield(get_tree().create_timer(5), "timeout")
			max_speed = MAX_SPEED_NORMAL
		1: # Jump
			max_jump_height = MAX_JUMP_HEIGHT_POWERUP
			yield(get_tree().create_timer(5), "timeout")
			max_jump_height = MAX_JUMP_HEIGHT_NORMAL

func _on_DropPlataformArea_body_exited(_body):
	set_collision_mask_bit(DROP_THRU_BIT, true)

func hit_checkpoint() -> void:
	Global.checkpoint_position = position
	Global.is_checkpoint_hitted = true
