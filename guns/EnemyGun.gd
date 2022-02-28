extends Sprite

# Constants
const MUZZLE_POS_FLIP_TRUE = 4.625
const MUZZLE_POS_FLIP_FALSE = -4.8
const RECOIL = 20

# Variables
var can_fire = true
var velocity = Vector2(0, 0)

# Scene Referecing
var bullet = preload("res://others/bullet/EnemyBullet.tscn")

# Nodes Referecing
onready var muzzle = $Muzzle
onready var player_pos = get_tree().current_scene.get_node("Player")

func _ready() -> void:
	set_as_toplevel(true)

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
	yield(get_tree().create_timer(0.5), "timeout")
	can_fire = true

func _physics_process(_delta: float) -> void:
	position += velocity
	velocity = velocity * 0.7
	
	global_position.x = lerp(global_position.x, get_parent().global_position.x, 0.4)
	global_position.y = lerp(global_position.y, get_parent().global_position.y + 40, 0.4)
	
	look_at(player_pos.global_position)
	
	# Flipping gun
	if player_pos.global_position.x < global_position.x:
		flip_v = true
		muzzle.position.y = MUZZLE_POS_FLIP_TRUE
		rotation_degrees += 20
	else:
		flip_v = false
		muzzle.position.y = MUZZLE_POS_FLIP_FALSE
		rotation_degrees -= 20
	
	if get_parent().founded && can_fire:
		shotting()
