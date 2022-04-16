extends RigidBody2D

# Node Referencing
onready var sprite = $Sprite

# Variables
export(Array, StreamTexture)var gun_textures

func _physics_process(_delta) -> void:
	sprite.rotation_degrees += 1
