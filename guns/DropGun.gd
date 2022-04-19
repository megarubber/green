extends RigidBody2D

# Node Referencing
onready var sprite = $Sprite
onready var collision = $CollisionShape2D

# Variables
export(Array, StreamTexture)var gun_textures

func _ready():
	var t_d = Timer.new()
	t_d.set_wait_time(5)
	t_d.set_one_shot(true)
	self.add_child(t_d)
	t_d.start()
	yield(t_d, "timeout")
	queue_free()

func _process(_delta) -> void:
	sprite.rotation_degrees += 1

func set_gun_texture(text) -> void:
	sprite.texture = gun_textures[text]
