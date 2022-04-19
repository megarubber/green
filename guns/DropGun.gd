extends RigidBody2D

# Node Referencing
onready var sprite = $Sprite

# Variables
export(Array, StreamTexture)var gun_textures

func _ready():
	yield(get_tree().create_timer(5), "timeout")
	queue_free()

func _physics_process(_delta) -> void:
	sprite.rotation_degrees += 1

func set_gun_texture(text) -> void:
	sprite.texture = gun_textures[text]
