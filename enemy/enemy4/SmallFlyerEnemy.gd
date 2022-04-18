extends KinematicBody2D

# General Variables
var motion = Vector2.ZERO
var founded = false
var speed = 5

# Node Referencing
onready var lifebar = $Lifebar
onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var l_damage_area = $LeftDamageArea
onready var r_damage_area = $RightDamageArea
onready var collider = $CollisionShape2D
onready var explosions = $Explosion

# Get Player Node
onready var player = get_tree().get_current_scene().get_node("Player")

func _ready() -> void:
	explosions.visible = false

# Function that runs when the enemy dies
func death() -> void:
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
	
	# Wait a time before delete enemy
	var t_d = Timer.new()
	t_d.set_wait_time(0.3)
	t_d.set_one_shot(true)
	self.add_child(t_d)
	t_d.start()
	yield(t_d, "timeout")
	queue_free()

func _physics_process(_delta) -> void:
	if founded && !lifebar.getDeath():
		motion = global_position.direction_to(player.global_position) * speed	
	else:
		motion = Vector2.ZERO
	sprite.rotation_degrees += 1
	motion = move_and_collide(motion)
	
	if l_damage_area.monitoring && r_damage_area.monitoring:
		if l_damage_area.get_overlapping_areas():
			if l_damage_area.get_overlapping_areas()[0].get_name() == "DamageArea":
				speed = 0
				if !player.hit:
					player.take_damage(5)
					Global.hit_side = -1
			elif l_damage_area.get_overlapping_areas()[0].get_name() == "flame_area":
				take_damage(10)
			else:
				speed = 5
		elif r_damage_area.get_overlapping_areas():
			if r_damage_area.get_overlapping_areas()[0].get_name() == "DamageArea":
				speed = 0
				if !player.hit:
					player.take_damage(5)
					Global.hit_side = 1
			elif r_damage_area.get_overlapping_areas()[0].get_name() == "flame_area":
				take_damage(10)
			else:
				speed = 5
		else:
			speed = 5
	
func _process(_delta) -> void:
	# Tests if enemy is dead
	if lifebar.getDeath():
		death()

func _on_DetectArea_body_entered(body) -> void:
	if body.is_in_group("player"):
		founded = true

func _on_DetectArea_body_exited(body) -> void:
	if body.is_in_group("player"):
		founded = false

func which_damage(area):
	if area.is_in_group("bullet-base"):
		take_damage(50)
		area.queue_free()
	elif area.is_in_group("bullet-spread"):
		take_damage(50)
		area.queue_free()
	elif area.is_in_group("bullet-pistol"):
		take_damage(25)
		area.queue_free()
	elif area.is_in_group("bullet-autoaim"):
		take_damage(25)
		area.queue_free()

func _on_LeftDamageArea_area_entered(area) -> void:
	Global.hit_side = -1
	which_damage(area)

func _on_RightDamageArea_area_entered(area):
	Global.hit_side = 1
	which_damage(area)

# take damage
func take_damage(damage : int) -> void:
	anim.play("flash")
	lifebar.damage(damage)
