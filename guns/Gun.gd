extends Sprite

# Constants
const MUZZLE_POS_FLIP_TRUE = 4.625
const MUZZLE_POS_FLIP_FALSE = -4.8

# Variables
var can_fire = true
var recoil = 30

# Scene Referecing
var bullet = preload("res://guns/Bullet.tscn")

# Nodes Referecing
onready var muzzle = $Muzzle

func _ready():
	set_as_toplevel(true)


func shotting() -> void: # Shotting with gun
	global_position.x = lerp(global_position.x - recoil, get_parent().global_position.x, 0.7)
	var bullet_instance = bullet.instance()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	can_fire = false
	yield(get_tree().create_timer(0.2), "timeout")
	can_fire = true

func _physics_process(_delta):
	global_position.x = lerp(global_position.x, get_parent().global_position.x, 0.4)
	global_position.y = lerp(global_position.y, get_parent().global_position.y - 90, 0.4)
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	# Flipping gun
	if get_parent().get_local_mouse_position().x < 0:
		flip_v = true
		muzzle.position.y = MUZZLE_POS_FLIP_TRUE
		recoil = 30
	else:
		flip_v = false
		muzzle.position.y = MUZZLE_POS_FLIP_FALSE
		recoil = -30
	
	# Press the left button mouse to shoot
	if Input.is_action_pressed("ui_fire") && can_fire:
		shotting()
