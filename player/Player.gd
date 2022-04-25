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
const PUSH_FORCE = 30

# General Variables
var motion = Vector2()
export var start_position_level = Vector2()
var hit = false
var max_speed = MAX_SPEED_NORMAL
var max_jump_height = -850
var can_fly = true
var jump_in_trampoline = false
var is_pushing = false
var finish = false

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
onready var dust_timer = $DustTimer
onready var foot_dust = $FootDust
onready var push_right = $PushRight
onready var push_left = $PushLeft
onready var hands = $Hands
onready var jump_sound_effect = $JumpSoundEffect
onready var hit_sound_effect = $HitSoundEffect
onready var death_sound_effect = $DeathSoundEffect
onready var d_gun_sfx = $DropGunSoundEffect

# Referencing lifebar from HUD
onready var lifebar = get_tree().get_current_scene().get_node("HUD/Health/Lifebar")

# Drop Gun
onready var drop_gun = preload("res://guns/DropGun.tscn")

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
	var f = get_parent().get_node("FinishLevel/FinishLevel")
	f.connect("finished_level", self, "_finish_level")

func animation() -> void: # Player's animation function
	if is_on_floor() && !lifebar.getDeath():
		if dust_timer.is_stopped():
			foot_dust.emitting = true
			foot_dust.global_position = global_position
			dust_timer.start(foot_dust.lifetime + 0.1)
		if motion.x != 0 || is_pushing:
			anim.play("run")
			enable_push(true)
		else:
			anim.play("idle")
			enable_push(false)
	elif !is_on_floor() && !lifebar.getDeath():
		if motion.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
			jump_in_trampoline = false

func _finish_level() -> void:
	body_sprite.flip_h = false
	head_sprite.flip_h = false
	gun.flip_v = false
	Global.finished_level = true
	Global.total_score += (Global.score * Global.life)
	anim.play("finish_level")
	if gun.gun_type != gun.NO_GUN:
		gun.visible = true
		hands.visible = false
	else:
		gun.visible = false
		hands.visible = true	

func enable_push(value : bool) -> void:
	push_right.set_enabled(value)
	push_left.set_enabled(value)

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
				jump_sound_effect.play()
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
	set_z_index(7)
	Global.inventory_guns.clear()
	hands.get_node("hand-right").set_z_index(0)
	gun.visible = false
	hands.visible = true
	motion.x = 0
	if can_fly:	
		motion.y = min(0, motion.y - 30)
		anim_eyes.play("damage")
		anim.play("dead")
	if !wings.visible:
		if gun.gun_type < 5:
			dropping_gun(gun.gun_type)
		death_sound_effect.play()
		Global.play_music("res://audio/music/death-theme.ogg")
		Global.life -= 1
		emit_signal("player_death")
		wings.visible = true
		ring.visible = true
		deactivate_all_colliders()
		Global.is_playing = false

func dropping_gun(which_gun : int) -> void:
	d_gun_sfx.play()
	var g = drop_gun.instance()
	g.global_position = gun.position
	g.apply_central_impulse(Vector2.UP * 200)
	var random = String(round(rand_range(1, 1000000)))
	var g_name = "DropGun" + random
	g.set_name(g_name)
	#add_child(g)
	call_deferred("add_child", g)
	yield(get_tree().create_timer(0.01), "timeout")
	g = get_node(g_name)
	g.sprite.set_flip_h(get_global_mouse_position().x < global_position.x)
	g.set_gun_texture(which_gun)
	
func deactivate_all_colliders() -> void:
	drop.monitorable = false
	drop.monitoring = false
	damage_area.monitorable = false
	damage_area.monitoring = false
	collider.disabled = true

func _physics_process(delta: float) -> void: # Physics update
	if !Global.finished_level:
		movement()
	
	if push_right.is_colliding():
		var object = push_right.get_collider()
		object.move_and_slide(Vector2(PUSH_FORCE, 0) * max_speed * delta)
		if !object.is_on_wall():
			is_pushing = true
		else:
			is_pushing = false
	elif push_left.is_colliding():
		var object = push_left.get_collider()
		object.move_and_slide(Vector2(-PUSH_FORCE, 0) * max_speed * delta)
		if !object.is_on_wall():
			is_pushing = true
		else:
			is_pushing = false
	else:
		is_pushing = false
	
func _process(_delta: float) -> void:
	if !Global.finished_level:
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
				area.queue_free()
			"sword_enemy": # Executing in MeleeEnemy script (I don't know why)
				strength = 8
			"small_flyer_enemy":
				strength = 5
			"fire_trap":
				strength = 15
			"spike":
				strength = 10
				if lifebar.life > strength:	
					knockback_vertical(1700)
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
	
	# Hide gun or hands (type of gun = 5)
	if gun.gun_type != 5:	
		gun.visible = value
		hands.visible = false
	else:
		gun.visible = false
		hands.visible = value
	
	#if lifebar.getDeath():
	#	wings.visible = value
	#	ring.visible = value	

func knockback_horizontal(side, knockback_force) -> void:
	var knock_side = knockback_force * side
	motion.x -= lerp(motion.x, -knock_side, 0.1)
	motion = move_and_slide(motion, UP)
	
func knockback_vertical(knockup) -> void:
	motion.y = lerp(0, -knockup, 0.6)
	motion = move_and_slide(motion, UP)
	
func take_damage(strength : int) -> void:
	knockback_horizontal(Global.hit_side, 15000)
	#knockback_vertical()
	hit = true
	hit_sound_effect.play()
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

func _powerup(type) -> void:
	match type:
		0: # Speed
			max_speed = MAX_SPEED_POWERUP
			yield(get_tree().create_timer(5), "timeout")
			max_speed = MAX_SPEED_NORMAL
		1: # Jump
			max_jump_height = MAX_JUMP_HEIGHT_POWERUP
			yield(get_tree().create_timer(5), "timeout")
			max_jump_height = MAX_JUMP_HEIGHT_NORMAL

func _on_DropPlataformArea_body_exited(_body) -> void:
	set_collision_mask_bit(DROP_THRU_BIT, true)

func hit_checkpoint() -> void:
	Global.checkpoint_position = position
	Global.is_checkpoint_hitted = true
