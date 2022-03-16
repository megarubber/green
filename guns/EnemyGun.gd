extends Sprite

# Constants
const MUZZLE_POS_FLIP_TRUE = 4.7
const MUZZLE_POS_FLIP_FALSE = -8
const RECOIL = 20

# Variables
var can_fire = true
var velocity = Vector2(0, 0)
var timer = null
var delay = 0.5

# Scene Referecing
var bullet = preload("res://others/bullet/EnemyBullet.tscn")

# Nodes Referecing
onready var muzzle = $Muzzle
onready var player_pos = get_tree().current_scene.get_node("Player")

func _ready() -> void:
	# Creating Timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_complete") 
	add_child(timer)
	
	set_as_toplevel(true)

# When timer ends
func on_timeout_complete() -> void:
	can_fire = true

func shotting() -> void: # Shotting with gun
	var bullet_instance = bullet.instance()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = muzzle.global_position
	
	# Recoil
	var dir = Vector2(1, 0).rotated(global_rotation)
	var kickdirection = RECOIL * (dir * -1)
	velocity = velocity + kickdirection
	
	get_parent().add_child(bullet_instance)
	can_fire = false
	timer.start()

func _physics_process(_delta: float) -> void:	
	position += velocity
	velocity = velocity * 0.7
	
	global_position.x = lerp(global_position.x, get_parent().global_position.x, 0.4)
	global_position.y = lerp(global_position.y, get_parent().global_position.y + 40, 0.4)
	
	# Flipping gun
	if player_pos.global_position.x < global_position.x && get_parent().founded:
		flip_v = true
		muzzle.position.y = MUZZLE_POS_FLIP_TRUE
		change_gun_rotation(10, 3.2)
	else:
		flip_v = false
		muzzle.position.y = MUZZLE_POS_FLIP_FALSE
		change_gun_rotation(-10, 0)
		
	if get_parent().founded && can_fire:
		shotting()

# Change gun rotation function if player is found
func change_gun_rotation(radius_founded: int, rotation_not_found: float) -> void:
	if get_parent().founded:
		look_at(player_pos.global_position)
		rotation_degrees += radius_founded
	else:
		rotation = lerp_angle(rotation, rotation_not_found, 0.3)
