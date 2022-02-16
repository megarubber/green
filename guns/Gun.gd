extends Sprite

# Constants
const MUZZLE_POS_FLIP_TRUE = 4.625
const MUZZLE_POS_FLIP_FALSE = -4.8
const RECOIL = 20

# Variables
var can_fire = true
var velocity = Vector2(0, 0)
var mouse_pos = Vector2(0, 0)

# Scene Referecing
var bullet = preload("res://guns/Bullet.tscn")

# Nodes Referecing
onready var muzzle = $Muzzle
onready var drop = $Drop

func _ready():
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
	get_parent().screen_shake.shake(0.2, 2)
	can_fire = false
	yield(get_tree().create_timer(0.2), "timeout")
	can_fire = true

func _physics_process(_delta):
	position += velocity
	velocity = velocity *0.7
	global_position.x = lerp(global_position.x, get_parent().global_position.x, 0.4)
	global_position.y = lerp(global_position.y, get_parent().global_position.y - 90, 0.4)
	
	mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	# Flipping gun
	if get_parent().get_local_mouse_position().x < 0:
		flip_v = true
		muzzle.position.y = MUZZLE_POS_FLIP_TRUE
	else:
		flip_v = false
		muzzle.position.y = MUZZLE_POS_FLIP_FALSE
	
	# Press the left button mouse to shoot
	if Input.is_action_pressed("ui_fire") && can_fire:
		shotting()
