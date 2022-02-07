extends Sprite

# Variables
var can_fire = false

func _ready():
	set_as_toplevel(true)

func shotting() -> void:
	

func _physics_process(delta):
	global_position.x = lerp(global_position.x, get_parent().global_position.x, 0.4)
	global_position.y = lerp(global_position.y, get_parent().global_position.y - 90, 0.4)
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	# Flipping gun
	if get_parent().get_local_mouse_position().x < 0:
		flip_v = true
	else:
		flip_v = false
		
	if Input.is_action_pressed("ui_fire"):
		shotting()
